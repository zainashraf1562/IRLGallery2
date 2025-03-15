//
//  IRLFeedView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

/*
 Task List:
 - add user post tab in feedview
    -database X
    -view
 - add Profilreview(optional)
 - clean up app ui
 - Turn to watchOS
 - filter by date
 */

import SwiftUI
import CoreLocation

struct IRLFeedView: View {
    @State var viewModel:IRLFeedViewModel
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            TabView {
                IRLPostsView(posts: viewModel.posts, selectedPost: $viewModel.selectedPost)
                    .tabItem {
                        Label("All Posts", systemImage: "list.dash")
                    }
                IRLPostsView(posts: viewModel.user.posts, selectedPost: $viewModel.selectedPost)
                    .tabItem {
                        Label("My Posts", systemImage: "person.fill")
                    }
                    .navigationTitle("My Posts")
            }
            .toolbarColorScheme(.light, for: .tabBar)
            Button {
                viewModel.updatePosts()
            } label: {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            .padding(.bottom, 75.0)
            
        }
        .sheet(item: $viewModel.selectedPost) { post in
            IRLDetailView(post: post, user: viewModel.user)
                
        }
        .sheet(isPresented: $viewModel.addPost, content: {
            AddIRLPostView(viewModel: AddIRLPostViewModel(viewModel.locationManager,viewModel.user))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.addPost=true
                    viewModel.updatePosts()
                } label: {
                    Image(systemName: "plus").foregroundStyle(Color("AppColor"))
                }

            }
        }
        .navigationBarBackButtonHidden(true)
        .background(.ultraThinMaterial)
        
    }
}

#Preview {
    
    IRLFeedView(viewModel: IRLFeedViewModel( UserModel(userName: "user1", email: "user1@gmail.com",  posts: [], profileImageURL: URL(string: "https://fastly.picsum.photos/id/455/200/200.jpg?hmac=YZhCbBjCYF0ha5dR9ElToDVwWcw05w0e4pAv5S9nZYg")!), LocationManager()))
}
