//
//  AddIRLPostViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/6/24.
//

import Foundation
import _PhotosUI_SwiftUI

@Observable
class AddIRLPostViewModel{
    var locationManager: LocationManager
    var user: UserModel
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
    var image:UIImage?{
        if let selectedImageData{
            return UIImage(data: selectedImageData)
        } else{
            return nil
        }
    }
    var headerText:String = ""
    
    init(_ locationManager:LocationManager, _ user:UserModel){
        self.locationManager=locationManager
        self.user = user
    }
    var emptyFields = false
    func addPost(){
        Task{
            do{
                let id = UUID()
                let imageURL = try await StorageManager.base.storeImage(with: selectedImageData!, fileName: "\(id)")
                let post = PostModel(id:UUID(), location: locationManager.location!, imageURL: imageURL, text: headerText, comments: [], email: user.email, date: Date(), privacy: PrivacyType.everyone, username: user.userName)
                try await DatabaseManager.base.addPost(post: post)
                headerText = ""
                selectedItem = nil
                selectedImageData = nil
                
            }catch{
                print(error)
            }
        }
    }
    
}
