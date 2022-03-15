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

    private var lobbyId: EntityID!
    private let userIsHost: Bool

    private let lobbyManager = FirebaseLobbyConnectorDelegate()

    init(lobbyId: EntityID? = nil) {
        self.lobbyId = lobbyId
        self.userIsHost = lobbyId == nil
        self.others = [LobbyUser]()

        let auth = AuthService()
        guard let userId = auth.getUserId() else {
            fatalError("User is expected to be logged in.")
        }

        self.user = LobbyUser(
            id: userId,
            displayName: auth.getUserDisplayName()
        )

        if userIsHost {
            createLobby()
        } else {
            joinLobby()
        }
    }

    private func createLobby() {
        lobbyId = lobbyManager.createLobby(userId: user.id)
    }

    private func joinLobby() {
        lobbyManager.joinLobby(userId: user.id, lobbyId: lobbyId)
    }
}
