//
//  CommentCellView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI

struct CommentCellView: View {
    @State var viewModel: CommentCellViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: viewModel.profileURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1)) //
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.comment.username)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(viewModel.comment.text)
                    .font(.body)
                    .foregroundColor(.black)
                Text(viewModel.comment.date, format: .dateTime) // Format date for better readability
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            Spacer()
        }
    }
}


#Preview {
    List {
        CommentCellView(viewModel: CommentCellViewModel(comment: CommentModel(username: "Fisrt Last",email: "User2@gmail.com", date: Date(), text: "Great post!"))
        )
        CommentCellView(viewModel: CommentCellViewModel(comment: CommentModel(username: "Fisrt Last",email: "User2@gmail.com", date: Date(), text: "Great post!"))
        )
    }
    .listRowBackground(Color.clear)
    .scrollContentBackground(.hidden)
}
