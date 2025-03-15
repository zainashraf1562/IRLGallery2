//
//  IRLPostsView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/27/24.
//

import SwiftUI
import CoreLocation

struct IRLPostsView: View {
    var posts: [PostModel]
    @Binding var selectedPost: PostModel?
    var body: some View {
        List(posts) { post in
            IRLFeedCellView(viewModel: IRLFeedCellViewModel(post: post))
                .onTapGesture(count: 2) {
                    selectedPost = post
                }
                .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    IRLPostsView(posts: Array(repeating: PostModel(id:UUID(),
                                                   location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                                   imageURL: URL(string: "https://fastly.picsum.photos/id/455/200/200.jpg?hmac=YZhCbBjCYF0ha5dR9ElToDVwWcw05w0e4pAv5S9nZYg")!,
                                                   text: "Beautiful day at the Golden Gate Bridge!",
                                                   comments: [
                                                    CommentModel(username: "Fisrt Last", email: "User2@gmail.com", date: Date(), text: "Cool")
                                                   ],
                                                   email: "User2@gmail.com",
                                                   date: Date(),
                                                   privacy: .everyone,
                                                   username: "jane"
                                                  ), count: 3), selectedPost: .constant(nil))
}
