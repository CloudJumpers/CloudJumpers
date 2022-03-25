//
//  AuthService.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 13/3/22.
//

import Foundation

class AuthService {
    private let authManager: AuthManager

    init(authManager: AuthManager = FirebaseAuthManager()) {
        self.authManager = authManager
    }

    func isLoggedIn() -> Bool {
        authManager.getCurrentUser() != nil
    }

    func signUp(email: String, password: String, name: String) async -> Bool {
        await authManager.createUser(email: email, password: password, name: name)
    }

    func logIn(email: String, password: String) async -> Bool {
        await authManager.loginUser(email: email, password: password)
    }

    func logOut() {
        authManager.logoutUser()
    }

    func getUserId() -> EntityID? {
        authManager.getCurrentUser()?.userId
    }

    func getUserDisplayName() -> String {
        authManager.getCurrentUser()?.displayName ?? "Unnamed Player"
    }
}
