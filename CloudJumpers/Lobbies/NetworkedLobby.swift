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

    let hostId: EntityID
    private(set) var id: EntityID!

    private let lobbyManager = FirebaseLobbyConnectorDelegate()

    var allUsers: [LobbyUser] {
        [user] + others
    }

    var userIsHost: Bool {
        hostId == AuthService().getUserId()
    }

    init(lobbyId: EntityID?, hostId: EntityID) {
        self.id = lobbyId
        self.hostId = hostId
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

    func addUser(newUser: LobbyUser) {
        guard newUser.id != user.id else {
            return
        }
        others.append(newUser)
    }

    func removeAllOtherUsers() {
        others.removeAll()
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

    func setAsReady() {
        lobbyManager.setReady(lobbyId: id)
    }

    func exitLobby() {
        lobbyManager.exitLobby(
            lobbyId: id,
            deleteLobby: userIsHost
        )
    }
}
