//
//  SignUpViewModel.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 01/05/2023.
//
//TODO: creating account

import Foundation

class SignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoggingIn = false
    @Published var showSignUpView = false

    func signUp(/*email: String, password: String*/) async {
        do {
            //try await app.emailPasswordAuth.registerUser(email: email, password: password)
            print("Successfully registered user")
            //await login(/*email: email, password: password*/)
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
            //errorHandler.error = error
        }
    }
}
