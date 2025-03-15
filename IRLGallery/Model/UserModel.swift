//
//  UserModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation
import CoreLocation

struct UserModel:Codable, Hashable{
    let userName:String
    let email:String
    var posts:[PostModel]
    var profileImageURL:URL
    init(userName: String, email: String, posts: [PostModel], profileImageURL: URL) {
        self.userName = userName
        self.email = email
        self.posts = posts
        self.profileImageURL=profileImageURL
    }
    // Custom hash implementation focusing on the `email` field
    func hash(into hasher: inout Hasher) {
        hasher.combine(email) // Use email for hashing since it's typically unique per user
    }
    
    // Custom equality check to match based on email
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.email == rhs.email
    }
}
