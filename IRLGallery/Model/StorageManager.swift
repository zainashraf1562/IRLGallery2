//
//  StorageManager.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/13/24.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let base = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    func storeImage(with data: Data, fileName: String) async throws -> URL {
        let storageRef = storage.child("messageImages/\(fileName)")
        // Upload data
        try await storageRef.putDataAsync(data)
        // Get download URL
        return try await storageRef.downloadURL()
    }
    
    func getURL(for path: String) async throws -> URL {
        let reference = storage.child(path)
        return try await reference.downloadURL()
    }
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
}
