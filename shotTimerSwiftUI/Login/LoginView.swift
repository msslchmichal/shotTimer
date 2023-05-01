//
//  LoginView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 24/04/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State var isShowingAlert = false
    @State private var showSignUp = false
    
    var body: some View {
        VStack {
            if viewModel.isLoggingIn {
                ProgressView()
            }
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button("Log In") {
                    viewModel.isLoggingIn = true
                    Task {
                        do {
                            try await viewModel.login(email: viewModel.email, password: viewModel.password)
                            viewModel.isLoggingIn = false
                        } catch {
                            
                            viewModel.isLoggingIn = false
                            isShowingAlert = true
                        }
                    }
                    
                }
                .disabled(viewModel.isLoggingIn)
                .frame(width: 150, height: 50)
                .background(Color(red: 0.25, green: 0.59, blue: 0.22))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $viewModel.isShowingAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.loginError!), dismissButton: .default(Text("OK")))
                }
                
                Button(action: {
                    showSignUp.toggle()
                }, label: {
                    Text("Don't have an accout yet? Sign Up!")
                    
                })
                .disabled(viewModel.isLoggingIn)
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $showSignUp) {
                    SignUpView()
                }
                Text("Please log in or register with a Device Sync user account. This is separate from your Atlas Cloud login")
                    .font(.footnote)
                    .padding(20)
                    .multilineTextAlignment(.center)
            }.padding(20)
        }
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
