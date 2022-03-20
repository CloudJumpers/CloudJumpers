//
//  FirebaseAuthManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 9/3/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager: AuthManager {
    private let authenticator = FirebaseAuth.Auth.auth()

    func loginUser(email: String, password: String) async -> Bool {
        do {
            try await authenticator.signIn(withEmail: email, password: password)
            return true
        } catch {
            return false
        }
    }

    func logoutUser() {
        do {
            try authenticator.signOut()
        } catch {
            print("Unable to log user out: \(error.localizedDescription)")
        }
    }

    func createUser(email: String, password: String, name: String? = nil) async -> Bool {
        do {
            try await authenticator.createUser(withEmail: email, password: password)

            guard let displayName = name, let user = authenticator.currentUser else {
                return true
            }

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()

            return true
        } catch {
            return false
        }
    }

    func deleteCurrentUser() async -> Bool {
        guard let user = authenticator.currentUser else {
            return false
        }

        do {
            try await user.delete()
            return true
        } catch {
            return false
        }
    }

    func getCurrentUser() -> AuthInfo? {
        guard let user = authenticator.currentUser else {
            return nil
        }

        return AuthInfo(userId: user.uid, displayName: user.displayName)
    }
}
