//
//  NetworkedLobby.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

class NetworkedLobby {
    private var user: LobbyUser
    private(set) var others: [LobbyUser]

    let hostId: EntityID
    private(set) var id: EntityID!

    private let lobbyManager = FirebasePublisherDelegate()
    private var onLobbyFinalized: NetworkCallback?

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
        processLobbyUpdate()
    }

    func updateOtherUser(_ updatedUser: LobbyUser) {
        guard let index = others.firstIndex(where: { $0.id == updatedUser.id }) else {
            return
        }

        others[index] = updatedUser
        processLobbyUpdate()
    }

    func removeAllOtherUsers() {
        others.removeAll()
    }

    func setUserReady() {
        guard !user.isReady else {
            return
        }

        user.setAsReady()
        processLobbyUpdate()
    }

    func setUserNotReady() {
        guard user.isReady else {
            return
        }

        user.setAsNotReady()
    }

    func removeOtherUser(userId: EntityID) {
        others = others.filter { $0.id != userId }
    }

    func toggleReady() {
        lobbyManager.toggleReady(lobbyId: id)
    }

    func setOnFinalizedCallback(callback: NetworkCallback?) {
        onLobbyFinalized = callback
    }

    private func createLobby() {
        id = lobbyManager.createLobby()
    }

    private func joinLobby() {
        lobbyManager.joinLobby(lobbyId: id)
    }

    private var isLobbyFinalized: Bool {
        allUsers.count == LobbyConstants.MaxSupportedPlayers && allUsers.allSatisfy({ $0.isReady })
    }

    private func processLobbyUpdate() {
        if isLobbyFinalized {
            onLobbyFinalized?()
        }
    }

    func exitLobby() {
        lobbyManager.exitLobby(
            lobbyId: id,
            deleteLobby: userIsHost
        )
    }
}
