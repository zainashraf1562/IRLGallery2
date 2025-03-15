//
//  IRLDetailView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI
import CoreLocation

// likes and commints

struct IRLDetailView: View {
    let post: PostModel
    let user: UserModel
    var body: some View {
        VStack{
            IRLFeedCellView(viewModel:IRLFeedCellViewModel(post: post))
            
            CommentsView(viewModel: CommentsViewModel(user: user, postId: post.id))
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    IRLDetailView(post: PostModel(id:UUID(), 
        location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        imageURL: URL(string: "https://fastly.picsum.photos/id/621/200/800.jpg?hmac=Ss5kTUppvDe6AkgGJ20DbXstc1cdsv2eyY0KKwGW0p8")!,
        text: "Beautiful day at the Golden Gate Bridge!",
        comments: [
             CommentModel(username: "Fisrt Last", email: "joe@gmail.com", date: Date(), text: "Cool")
        ],
        email: "janesmith@example.com",
        date: Date(),
        privacy: .everyone,
        username: "Jane"),user:UserModel(userName: "name", email: "email.com", posts: [], profileImageURL: URL(string: "https://fastly.picsum.photos/id/455/200/200.jpg?hmac=YZhCbBjCYF0ha5dR9ElToDVwWcw05w0e4pAv5S9nZYg")!))
}
