//
//  GameLobby.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

enum LobbyState {
    case matchmaking
    case gameInProgress
    case disconnected
}

class GameLobby: NetworkedLobby {
    let id: EntityID
    private(set) var name: String
    private(set) var gameMode = GameMode.TimeTrial

    let hostId: EntityID
    private(set) var users: [LobbyUser] = [LobbyUser]()

    var updater: LobbyUpdaterDelegate?
    var listener: ListenerDelegate?

    var onLobbyStateChange: LobbyLifecycleCallback?
    var onLobbyNameChange: LobbyMetadataCallback?
    var onLobbyGameModeChange: LobbyMetadataCallback?

    var numUsers: Int {
        users.count
    }

    var userIsHost: Bool {
        hostId == AuthService().getUserId()
    }

    private var isLobbyFinalized: Bool {
        users.count == LobbyConstants.MaxSupportedPlayers && users.allSatisfy({ $0.isReady })
    }

    /// Constructor for creating a lobby hosted by the device user
    init?(
        onLobbyStateChange: LobbyLifecycleCallback? = nil,
        onLobbyNameChange: LobbyMetadataCallback? = nil,
        onLobbyGameModeChange: LobbyMetadataCallback? = nil
    ) {
        self.id = LobbyUtils.generateLobbyId()
        self.name = LobbyUtils.generateLobbyName()
        self.onLobbyStateChange = onLobbyStateChange
        self.onLobbyNameChange = onLobbyNameChange
        self.onLobbyGameModeChange = onLobbyGameModeChange

        let auth = AuthService()
        let deviceUserDisplayName = auth.getUserDisplayName()
        guard auth.isLoggedIn(), let deviceUserId = auth.getUserId() else {
            return nil
        }

        self.hostId = deviceUserId
        self.users.append(LobbyUser(id: deviceUserId, displayName: deviceUserDisplayName, isReady: false))

        self.updater = FirebaseUpdaterDelegate()
        self.listener = FirebaseListenerDelegate(lobbyId: self.id)

        updater?.managedLobby = self
        listener?.managedLobby = self

        createLobby(hostId: deviceUserId, hostDisplayName: deviceUserDisplayName)
        assert(checkRepresentation())
    }

    /// Constructor for joining an externally created lobby
    init?(id: EntityID,
          name: String,
          hostId: EntityID,
          onLobbyStateChange: LobbyLifecycleCallback? = nil,
          onLobbyNameChange: LobbyMetadataCallback? = nil,
          onLobbyGameModeChange: LobbyMetadataCallback? = nil
    ) {
        self.id = id
        self.name = name
        self.hostId = hostId
        self.onLobbyStateChange = onLobbyStateChange
        self.onLobbyNameChange = onLobbyNameChange
        self.onLobbyGameModeChange = onLobbyGameModeChange

        let auth = AuthService()
        let deviceUserDisplayName = auth.getUserDisplayName()
        guard auth.isLoggedIn(), let deviceUserId = auth.getUserId() else {
            return nil
        }

        self.users.append(LobbyUser(id: deviceUserId, displayName: deviceUserDisplayName, isReady: false))

        self.updater = FirebaseUpdaterDelegate()
        self.listener = FirebaseListenerDelegate(lobbyId: self.id)

        updater?.managedLobby = self
        listener?.managedLobby = self

        joinLobby(userId: deviceUserId, userDisplayName: deviceUserDisplayName)
        assert(checkRepresentation())
    }

    private func createLobby(hostId: EntityID, hostDisplayName: String) {
        updater?.createLobby(hostId: hostId, hostDisplayName: hostDisplayName)
    }

    private func joinLobby(userId: EntityID, userDisplayName: String) {
        updater?.joinLobby(userId: userId, userDisplayName: userDisplayName)
    }

    private func checkRepresentation() -> Bool {
        users.contains { $0.id == hostId }
    }

    // MARK: - Callbacks
    func onLobbyConnectionOpen() {
        onLobbyStateChange?(self, .matchmaking)
    }

    func onLobbyUsersFinalized() {
        guard isLobbyFinalized else {
            return
        }

        onLobbyStateChange?(self, .gameInProgress)
    }

    func onLobbyConnectionClosed() {
        onLobbyStateChange?(self, .disconnected)
    }

    func onGameModeChange(_ newGameMode: GameMode) {
        gameMode = newGameMode
        onLobbyGameModeChange?(newGameMode.rawValue)
    }

    func onNameChange(_ newName: String) {
        name = newName
        onLobbyNameChange?(newName)
    }

    // MARK: - External actions
    func onUserAdd(_ user: LobbyUser) {
        guard !users.contains(user) else {
            return
        }

        users.append(user)
        assert(checkRepresentation())
    }

    func onUserUpdate(_ user: LobbyUser) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            return
        }

        users[index] = user
        assert(checkRepresentation())
    }

    func onUserRemove(_ userId: EntityID) {
        users = users.filter { $0.id != userId }

        guard userId != AuthService().getUserId() else {
            removeDeviceUser()
            return
        }

        assert(checkRepresentation())
    }

    // MARK: - Device actions
    /// This function can be called to remove the local user from the lobby.
    /// After calling this function, the object should no longer be used.
    func removeDeviceUser() {
        guard let userId = AuthService().getUserId() else {
            return
        }

        updater?.exitLobby(userId: userId, deleteLobby: userIsHost)
    }

    func toggleDeviceUserReadyStatus() {
        guard let deviceUser = users.first(where: { $0.id == AuthService().getUserId() }) else {
            return
        }

        // It would be possible for us to optimistically set the user to ready here first
        // However, this may lead to fairness issues - the last user to become ready
        // will get to the finalized state before all other lobby users
        updater?.toggleReady(userId: deviceUser.id)
    }

    private func processLobbyUpdate() {
        guard isLobbyFinalized else {
            return
        }
        onLobbyUsersFinalized()
    }
}
