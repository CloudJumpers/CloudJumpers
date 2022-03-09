//
//  FirebaseAuthManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 9/3/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    private let authenticator = FirebaseAuth.Auth.auth()

    func loginUser(email: String, password: String) async -> User? {
        do {
            let loginAttempt = try await authenticator.signIn(withEmail: email, password: password)
            return loginAttempt.user
        } catch {
            return nil
        }
    }

    func createUser(email: String, password: String) async -> User? {
        do {
            let createUserAttempt = try await authenticator.createUser(withEmail: email, password: password)
            return createUserAttempt.user
        } catch {
            return nil
        }
    }

    func getActiveUser() -> User? {
        authenticator.currentUser
    }
}


