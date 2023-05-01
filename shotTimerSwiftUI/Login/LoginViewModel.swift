//
//  LoginViewModel.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 24/04/2023.
//

import Foundation
import RealmSwift

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoggingIn = false
    @Published var showAlert = false
    @Published var isShowingAlert = false
    @Published var loginError: String?

    func login(email: String, password: String) async throws {
        do {
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in user: \(email)")
        } catch {
            self.loginError = error.localizedDescription
            isShowingAlert = true
            print("catch")
            print("Failed to log in user: \(error.localizedDescription)")
            
        }
    }
}
