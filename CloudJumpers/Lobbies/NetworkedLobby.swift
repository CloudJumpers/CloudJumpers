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

    private(set) var id: EntityID!
    private let userIsHost: Bool

    private let lobbyManager = FirebaseLobbyConnectorDelegate()

    var allUsers: [LobbyUser] {
        [user] + others
    }

    init(lobbyId: EntityID? = nil) {
        self.id = lobbyId
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

    func addOtherUser(user: LobbyUser) {
        others.append(user)
    }

    func removeOtherUser(userId: EntityID) {
        others = others.filter { $0.id != userId }
    }

    private func createLobby() {
        id = lobbyManager.createLobby()
    }

    private func joinLobby() {
        lobbyManager.joinLobby(lobbyId: id)
    }
}
