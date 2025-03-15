//
//  SignupView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct RegisterView: View {
    @State var viewModel = RegisterViewModel()
    var body: some View {
        VStack{
            Spacer()
            ZStack(alignment: .topLeading){
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                PhotosPicker(selection: $viewModel.selectedItem) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .padding()
                        .background(Color(red: 0.0, green: 0.2, blue: 0.6))
                        .clipShape(Circle())
                }
            }
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color("AppColor").opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color("AppColor").opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color("AppColor").opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.register()
            }, label: {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.2, blue: 0.6))
                    .cornerRadius(10)
            })
            .padding(.horizontal)
            .navigationDestination(item: $viewModel.user, destination: { user in
                IRLFeedView(viewModel: IRLFeedViewModel(user,viewModel.locationManager))
            })
            .alert(viewModel.errorMessage, isPresented: $viewModel.incorrectRegistration) {
                Button("OK", role: .cancel) { viewModel.incorrectRegistration = false }
            }
            
            NavigationLink(
                destination: LoginView(),
                label: {
                    Text("Already have a account?")
                        .foregroundStyle(Color("AppColor"))
                        
                }
            )
            .padding(.horizontal)
            Spacer()
            Spacer()
            
        }
        .navigationBarHidden(true)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    RegisterView()
}
