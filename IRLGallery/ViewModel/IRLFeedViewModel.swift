//
//  IRLFeedViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation
import CoreLocation

@Observable
class IRLFeedViewModel{
    var user:UserModel
    var posts:[PostModel] = []
    var selectedPost: PostModel?
    var addPost: Bool = false
    var locationManager: LocationManager
    init(_ user:UserModel, _ locationManager:LocationManager){
        self.user = user
        self.locationManager = locationManager
        updatePosts()
        startLocationUpdates()
    }
    func updatePosts(){
        let location = locationManager.location
        Task{
            do{
                posts = try await DatabaseManager.base.getPosts(byPrivacyType: PrivacyType.everyone, within: 750, from: location!)
                user.posts = try await DatabaseManager.base.getUserPosts(userEmail: user.email)
            }catch{
                print(error)
            }
        }
    }
    func filterPosts() {
        guard let currentLocation = locationManager.location else {
            print("Current location is nil")
            return
        }
        
        posts = posts.filter { post in
            return calculateDistance(currentLocation,post.location) <= 750
        }
    }
    
    func startLocationUpdates() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.filterPosts()
        }
    }
    func calculateDistance(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        
        return location1.distance(from: location2) // Distance in meters
    }

}
