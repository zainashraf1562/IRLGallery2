//
//  SignupViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation
import FirebaseAuth
import _PhotosUI_SwiftUI

@Observable
class RegisterViewModel{
    var selectedItem: PhotosPickerItem? {
        didSet {
            selectedItem?.loadTransferable(type: Data.self, completionHandler: { result in
                switch result{
                case .success(let data):
                    self.selectedImageData=data
                case .failure(let error):
                    fatalError("\(error)")
                }
            })
        }
    }
    var selectedImageData: Data? = nil
    var image:UIImage{
        if let selectedImageData{
            return UIImage(data: selectedImageData)!
        } else{
            return UIImage(systemName: "person.circle")!
        }
    }
    var imageURL:URL?
    var username = ""
    var email = ""
    var password = ""
    var incorrectRegistration = false
    var user: UserModel?
    var locationManager: LocationManager = LocationManager()
    var errorMessage: String = "" {
        didSet{
            incorrectRegistration=true
        }
    }
    
    func register(){
        if  locationManager.manager.authorizationStatus != .authorizedAlways && locationManager.manager.authorizationStatus != .authorizedWhenInUse{
            locationManager.manager.requestWhenInUseAuthorization()
            return
        }
        Task{
            do{
                try await FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password)
                let imageData = selectedImageData ?? UIImage(systemName: "person.circle")!.pngData()!
                let imageURL = try await StorageManager.base.storeImage(with: imageData, fileName: "\(email)")
                user = UserModel(userName: username, email: email, posts: [], profileImageURL: imageURL)
                try await DatabaseManager.base.addUser(user: user!)
            }catch{
                let err = error as NSError
                if let errorCode = err.code as? Int {
                    switch errorCode {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        errorMessage = RegistrationErrors.emailAlreadyInUse.localizedDescription
                    case AuthErrorCode.invalidEmail.rawValue:
                        errorMessage = RegistrationErrors.invalidEmail.localizedDescription
                    case AuthErrorCode.weakPassword.rawValue:
                        errorMessage = RegistrationErrors.weakPassword.localizedDescription
                    default:
                        errorMessage = error.localizedDescription
                    }
                }
                errorMessage=error.localizedDescription
                self.incorrectRegistration = true
            }
        }
    }
    
}
enum RegistrationErrors: Error {
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    case systemError(message: String)

    var localizedDescription: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email address is already in use."
        case .invalidEmail:
            return "Invalid email address."
        case .weakPassword:
            return "Weak password."
        case .systemError(let message):
            return "System error: \(message)"
        }
    }
}
