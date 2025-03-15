//
//  DatabaseManager.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/7/24.
//
import Firebase
import FirebaseFirestore
import CoreLocation

class DatabaseManager {
    let db = Firestore.firestore()
    static let base = DatabaseManager()

    // MARK: - User Methods

    func addUser(user: UserModel) async throws {
        do {
            try db.collection("Users").document(user.email).setData(from: user)
        } catch {
            throw error
        }
    }

    func getUser(byEmail email: String) async throws -> UserModel {
        let document = try await db.collection("Users").document(email).getDocument()
        if document.exists {
            do {
                let user = try document.data(as: UserModel.self)
                return user
            } catch {
                throw error
            }
        } else {
            throw DatabaseErrors.noValidUserInDatabase
        }
    }

    func deleteUser(byEmail email: String) async throws {
        do {
            try await db.collection("Users").document(email).delete()
        } catch {
            throw error
        }
    }

    // MARK: - Post Methods

    func addPost(post: PostModel) async throws {
        let userDocRef = db.collection("Users").document(post.email)
        let postRef = db.collection("Posts").document(post.id.uuidString)
        
        // Compute the geohash for the post's location
        let geohash = CLLocationCoordinate2D(latitude: post.location.latitude, longitude: post.location.longitude).geohash(length: 8)  // Use 8 for moderate precision

        // Prepare the data dictionary including the geohash
        var postData = try Firestore.Encoder().encode(post)
        postData["geohash"] = geohash
        
        do {
            try await postRef.setData(postData)
            try await userDocRef.updateData([
                "posts": FieldValue.arrayUnion([postData])
            ])
        } catch {
            throw error
        }
    }

    func getPosts(byPrivacyType privacyType: PrivacyType, within distance: Double, from location: CLLocationCoordinate2D) async throws -> [PostModel] {
        // Compute the central geohash and additional nearby geohashes
        let centerGeohash = location.geohash(length: 8)  // Moderate precision
        print(centerGeohash)
        var geohashNeighbors = Geohash.neighbors(geohash: centerGeohash) // Hypothetical utility function

        // Include the center geohash in the search
        geohashNeighbors.append(centerGeohash)

        var posts = [PostModel]()
        for geohash in geohashNeighbors {
            let querySnapshot = try await db.collection("Posts")
                .whereField("privacy", isEqualTo: privacyType.rawValue)
                .whereField("geohash", isEqualTo: geohash)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let post = try document.data(as: PostModel.self)
                let postLocation = CLLocation(latitude: post.location.latitude, longitude: post.location.longitude)
                let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                
                // Further filter the results by the actual distance to handle edge cases
                if postLocation.distance(from: userLocation) <= distance {
                    posts.append(post)
                }
            }
        }
        return posts
    }
    
    func getUserPosts(userEmail: String) async throws -> [PostModel] {
        let userDoc = try await db.collection("Users").document(userEmail).getDocument()
        guard let userData = userDoc.data(), let postsData = userData["posts"] as? [[String: Any]] else {
            throw DatabaseErrors.noValidUserInDatabase
        }

        return postsData.compactMap { try? Firestore.Decoder().decode(PostModel.self, from: $0) }
    }
    
    
    
    // MARK: - Comment Methods
    
    func addComment(toPostWithID postID: UUID, comment: CommentModel) async throws {
        let commentRef = db.collection("Posts").document(postID.uuidString).collection("Comments").document()
        do {
            try commentRef.setData(from: comment)
        } catch {
            throw error
        }
    }
    
    func getComments(fromPostWithID postID: UUID) async throws -> [CommentModel] {
        let querySnapshot = try await db.collection("Posts").document(postID.uuidString).collection("Comments").getDocuments()
        return querySnapshot.documents.compactMap { document in
            try? document.data(as: CommentModel.self)
        }
    }
    
    func likePost(postID: UUID, userEmail: String) async throws {
        let likeRef = db.collection("Posts").document(postID.uuidString).collection("Likes").document(userEmail)
        do {
            try await likeRef.setData([
                "email": userEmail,
                "timestamp": FieldValue.serverTimestamp()
            ])
        } catch {
            throw error
        }
    }
    
    func unlikePost(postID: UUID, userEmail: String) async throws {
        let likeRef = db.collection("Posts").document(postID.uuidString).collection("Likes").document(userEmail)
        do {
            try await likeRef.delete()
        } catch {
            throw error
        }
    }
    
    func hasUserLikedPost(postID: UUID, userEmail: String) async throws -> Bool {
        let likeRef = db.collection("Posts").document(postID.uuidString).collection("Likes").document(userEmail)
        let document = try await likeRef.getDocument()
        return document.exists
    }
    
    func countLikes(postID: UUID) async throws -> Int {
        let querySnapshot = try await db.collection("Posts").document(postID.uuidString).collection("Likes").getDocuments()
        return querySnapshot.documents.count
    }
    
}

enum DatabaseErrors: Error {
    case noValidUserInDatabase
}
