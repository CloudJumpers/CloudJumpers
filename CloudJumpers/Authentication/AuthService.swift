//
//  AuthService.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 13/3/22.
//

import Foundation

typealias PlayerUUID = String

class AuthService {
    private let authManager: AuthManager

    init(authManager: AuthManager = FirebaseAuthManager()) {
        self.authManager = authManager
    }

    func isLoggedIn() -> Bool {
        authManager.getCurrentUser() != nil
    }

    func getUserId() -> UUID? {
        guard
            let user = authManager.getCurrentUser(),
            let uuid = UUID(uuidString: user.userId)
        else {
            return nil
        }

        return uuid
    }

    func getUserDisplayName() -> String {
        authManager.getCurrentUser()?.displayName ?? "Unnamed Player"
    }
}
