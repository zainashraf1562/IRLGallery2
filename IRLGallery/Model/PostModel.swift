//
//  PostModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation
import CoreLocation

struct PostModel: Identifiable, Codable {
    let id: UUID
    let location: CLLocationCoordinate2D
    let imageURL: URL
    let text: String
    var comments: [CommentModel]
    let email: String
    let username: String
    let date: Date
    let privacy: PrivacyType

    init(id:UUID,location: CLLocationCoordinate2D, imageURL: URL, text: String, comments: [CommentModel], email: String, date: Date, privacy: PrivacyType, username: String) {
        self.id = id
        self.location = location
        self.imageURL = imageURL
        self.text = text
        self.comments = comments
        self.email = email
        self.date = date
        self.privacy = privacy
        self.username = username
    }

    enum CodingKeys: String, CodingKey {
        case id, location, imageURL, text, comments, email, date, privacy, username
    }

    enum LocationCodingKeys: String, CodingKey {
        case latitude, longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(text, forKey: .text)
        try container.encode(comments, forKey: .comments)
        try container.encode(email, forKey: .email)
        try container.encode(date, forKey: .date)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(username, forKey: .username)
        
        var locationContainer = container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        try locationContainer.encode(location.latitude, forKey: .latitude)
        try locationContainer.encode(location.longitude, forKey: .longitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
        text = try container.decode(String.self, forKey: .text)
        comments = try container.decode([CommentModel].self, forKey: .comments)
        email = try container.decode(String.self, forKey: .email)
        date = try container.decode(Date.self, forKey: .date)
        privacy = try container.decode(PrivacyType.self, forKey: .privacy)
        username = try container.decode(String.self, forKey: .username)
        
        let locationContainer = try container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        let latitude = try locationContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try locationContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum PrivacyType: String, Codable {
    case selfPrivate = "selfPrivate"
    case connection = "connection"
    case everyone = "everyone"
}
