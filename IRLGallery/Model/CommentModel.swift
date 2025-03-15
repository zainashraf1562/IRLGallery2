//
//  CommentModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation

struct CommentModel:Identifiable, Codable{
    let id: UUID
    let email:String
    let username:String
    let date:Date
    let text:String
    init(username:String,email: String, date: Date, text: String) {
        self.email = email
        self.date = date
        self.text = text
        self.username = username
        self.id = UUID()
    }
}
