//
//  IRLFeedCellView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI
import CoreLocation

struct IRLFeedCellView: View {
    @State var viewModel:IRLFeedCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: viewModel.post.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: UIScreen.main.bounds.width,maxHeight: 450)
                    .clipped()
                
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            
            HStack(alignment: .center,spacing: 7){
                AsyncImage(url: viewModel.profileURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1)) 
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                Text(viewModel.post.username)
                    .bold()
                Text(viewModel.post.text)
                    .font(.body)
                Spacer()
            }
            .padding([.leading, .bottom, .trailing], 10)
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 7)
    }
}

#Preview {
    IRLFeedCellView(viewModel: IRLFeedCellViewModel(post: PostModel(id:UUID(),
                                                                    location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                                                    imageURL: URL(string: "https://fastly.picsum.photos/id/621/200/800.jpg?hmac=Ss5kTUppvDe6AkgGJ20DbXstc1cdsv2eyY0KKwGW0p8")!,
                                                                    text: "Beautiful day at the Golden Gate Bridge!",
                                                                    comments: [
                                                                        CommentModel(username: "Fisrt Last", email: "joe@gmail.com", date: Date(), text: "Cool")
                                                                    ],
                                                                    email: "janesmith@example.com",
                                                                    date: Date(),
                                                                    privacy: .everyone,
                                                                    username: "Jane"
                                                                   )))
}
