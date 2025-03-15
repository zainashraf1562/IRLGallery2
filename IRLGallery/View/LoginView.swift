//
//  LoginView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewModel()
    var body: some View {
        VStack{
            //Spacer()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("Login to IRLGallery")
                .font(.title.bold())
                .foregroundColor(Color("AppColor"))
                .padding()
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
                viewModel.login()
            }, label: {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.2, blue: 0.6))
                    .cornerRadius(10)
            })
            .padding(.horizontal)
            .navigationDestination(item: $viewModel.user, destination: { user in
                IRLFeedView(viewModel: IRLFeedViewModel(user, viewModel.locationManager))
            })
            .alert("Incorrect email or password", isPresented: $viewModel.incorrectCredentials) {
                Button("OK", role: .cancel) { viewModel.incorrectCredentials=false }
            }
            
            NavigationLink(
                destination: RegisterView(),
                label: {
                    Text("Don't have a account?")
                        .foregroundStyle(Color("AppColor"))
                        
                }
            )
            .padding(.horizontal)
            Spacer()
            Spacer()
        }
        .background(.ultraThinMaterial)
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
