//
//  LoginViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation
import FirebaseAuth

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var incorrectCredentials = false
    var user: UserModel? = nil
    var locationManager: LocationManager = LocationManager()
    func login() {
        if  locationManager.manager.authorizationStatus != .authorizedAlways && locationManager.manager.authorizationStatus != .authorizedWhenInUse{
            print(locationManager.manager.authorizationStatus.self)
            locationManager.manager.requestWhenInUseAuthorization()
            return
        }
        Task{
            do{
                try await FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password)
                user = try await DatabaseManager.base.getUser(byEmail: email)
                
            } catch{
                incorrectCredentials = true
            }
        }
    }
}
