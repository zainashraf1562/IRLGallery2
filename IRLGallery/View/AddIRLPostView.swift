//
//  AddIRLPostView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/6/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddIRLPostView: View {
  @State var viewModel: AddIRLPostViewModel
  @Environment(\.dismiss) var dismiss

  var body: some View {
      VStack(spacing: 20) {
          Text("Create Post")
              .foregroundStyle(.white)
              .font(.title)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity, alignment: .leading)
          
          ZStack(alignment: .topLeading) { // Image container
              if let image = viewModel.image {
                  Image(uiImage: image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(maxWidth: .infinity)
              } else {
                  // Placeholder view for when no image is selected
                  Color.gray.opacity(0.2)
                      .frame(width: .infinity, height: 400)
              }
              PhotosPicker(selection: $viewModel.selectedItem) {
                  Image(systemName: "camera")
                      .foregroundColor(.white)
                      .font(.system(size: 24, weight: .bold))
                      .padding()
                      .background(Color(red: 0.0, green: 0.2, blue: 0.6))
                      .clipShape(Circle())
              }
              .padding([.top, .leading])
              
          }
          
          TextField("Add a catchy title...", text: $viewModel.headerText)
              .textFieldStyle(.roundedBorder)
              .padding()
          
          Button {
              if viewModel.selectedImageData == nil || viewModel.headerText == "" {
                  viewModel.emptyFields = true
              } else {
                  viewModel.addPost()
                  dismiss()
              }
          } label: {
              Text("Post")
                  .foregroundColor(.white)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(Color(red: 0.0, green: 0.2, blue: 0.6))
                  .cornerRadius(10)
          }
          .disabled(viewModel.selectedImageData == nil || viewModel.headerText == "") // Disable button if fields empty
          .opacity(viewModel.selectedImageData == nil || viewModel.headerText == "" ? 0.5 : 1.0) // Adjust opacity for disabled state
          
          Spacer()
      }
      .padding()
      .background(
          LinearGradient(gradient: Gradient(colors: [Color.blue, Color(red: 0.0, green: 0.2, blue: 0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
              .edgesIgnoringSafeArea(.all))
      .alert("Please add an image and title for your post.", isPresented: $viewModel.emptyFields) {
          Button("OK", role: .cancel) {}
      }
  }
}


#Preview {
    AddIRLPostView(viewModel: AddIRLPostViewModel(LocationManager(), UserModel(userName: "user1", email: "user1@gmail.com",  posts: [], profileImageURL: URL(string: "https://fastly.picsum.photos/id/455/200/200.jpg?hmac=YZhCbBjCYF0ha5dR9ElToDVwWcw05w0e4pAv5S9nZYg")!)))
}
