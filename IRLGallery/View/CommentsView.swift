//
//  CommentsView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI

struct CommentsView: View {
    @State var viewModel: CommentsViewModel
    var body: some View {
        VStack{
            HStack(alignment:.center){
                Button(action: {
                    Task {
                        await viewModel.toggleLike()
                    }
                }) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.isLiked ? Color("AppColor") : .gray)
                }
                Spacer()
                Label("\(viewModel.comments.count)", systemImage: "bubble.left")
                    .font(.subheadline)
                    .foregroundColor(Color("AppColor"))
            }
            .padding(.horizontal)
            List(viewModel.comments) { comment in
                CommentCellView(viewModel: CommentCellViewModel(comment: comment))
            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            Spacer()
            HStack {
                TextField("Add a comment...", text: $viewModel.newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: viewModel.addComment) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("AppColor"))
                }
                .disabled(viewModel.newCommentText.isEmpty)
            }
            .padding()
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    CommentsView(viewModel: CommentsViewModel(user: UserModel(userName: "name", email: "email.com", posts: [], profileImageURL: URL(string: "https://fastly.picsum.photos/id/455/200/200.jpg?hmac=YZhCbBjCYF0ha5dR9ElToDVwWcw05w0e4pAv5S9nZYg")!), postId: UUID()))
}
