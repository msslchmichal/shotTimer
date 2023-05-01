//
//  SignUpView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 01/05/2023.
//
// TODO: creating account

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoggingIn {
               ProgressView()
            }
            VStack {
                Text("Sign Up")
                    .font(.title)
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                //SecureField("Confirm Password", text: $viewModel.password)
                //   .textFieldStyle(.roundedBorder)

                Button("Create Account") {
                    viewModel.isLoggingIn = true
                    Task {
                        await viewModel.signUp(/*email: viewModel.email, password: viewModel.password*/)
                        viewModel.isLoggingIn = false
                    }
                }
                .disabled(viewModel.isLoggingIn)
                .frame(width: 150, height: 50)
                .background(Color(red: 0.25, green: 0.59, blue: 0.22))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }.padding(20)
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
