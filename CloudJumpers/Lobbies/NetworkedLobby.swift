//
//  LobbyNetwork.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

class NetworkedLobby {
    private let user: LobbyUser
    private(set) var others: [LobbyUser]

    private let userIsHost: Bool

    private let networkManager: NetworkingManager

    init() {
        self.networkManager = FirebaseRTDBManager()

        let authService = AuthService()
        guard let userId = authService.getUserId() else {
            fatalError("User is expected to be logged in.")
        }

        self.user = LobbyUser(
            id: userId,
            displayName: authService.getUserDisplayName()
        )

        self.others = [LobbyUser]()
        self.userIsHost = true
    }
}
