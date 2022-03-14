//
//  AuthManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 13/3/22.
//

import Foundation

protocol AuthManager {
    func loginUser(email: String, password: String) async -> Bool

    func createUser(email: String, password: String, name: String?) async -> Bool

    func deleteCurrentUser() async -> Bool

    func getCurrentUser() -> AuthInfo?
}
