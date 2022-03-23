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
    private(set) var gameMode = GameMode.TimeTrial  // TODO: refactor when new gamemodes exist
    private(set) var lobbyState: LobbyState?

    let hostId: EntityID
    private(set) var users: [LobbyUser] = [LobbyUser]()

    var updater: LobbyUpdaterDelegate?
    var listener: ListenerDelegate?
    var synchronizer: Synchronizer?

    var onLobbyStateChange: LobbyLifecycleCallback?
    var onLobbyDataChange: LobbyDataAvailableCallback?
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
        onLobbyDataChange: LobbyDataAvailableCallback? = nil,
        onLobbyNameChange: LobbyMetadataCallback? = nil,
        onLobbyGameModeChange: LobbyMetadataCallback? = nil
    ) {
        self.id = LobbyUtils.generateLobbyId()
        self.name = LobbyUtils.generateLobbyName()
        self.onLobbyStateChange = onLobbyStateChange
        self.onLobbyDataChange = onLobbyDataChange
        self.onLobbyNameChange = onLobbyNameChange
        self.onLobbyGameModeChange = onLobbyGameModeChange

        let auth = AuthService()
        let deviceUserDisplayName = auth.getUserDisplayName()
        guard auth.isLoggedIn(), let deviceUserId = auth.getUserId() else {
            return nil
        }

        self.hostId = deviceUserId
        self.updater = FirebaseUpdaterDelegate()
        self.listener = FirebaseListenerDelegate(lobbyId: self.id)

        updater?.managedLobby = self
        listener?.managedLobby = self

        createLobby(hostId: deviceUserId, hostDisplayName: deviceUserDisplayName)
    }

    /// Constructor for joining an externally created lobby
    init?(id: EntityID,
          name: String,
          hostId: EntityID,
          onLobbyStateChange: LobbyLifecycleCallback? = nil,
          onLobbyDataChange: LobbyDataAvailableCallback? = nil,
          onLobbyNameChange: LobbyMetadataCallback? = nil,
          onLobbyGameModeChange: LobbyMetadataCallback? = nil
    ) {
        self.id = id
        self.name = name
        self.hostId = hostId
        self.onLobbyStateChange = onLobbyStateChange
        self.onLobbyDataChange = onLobbyDataChange
        self.onLobbyNameChange = onLobbyNameChange
        self.onLobbyGameModeChange = onLobbyGameModeChange

        let auth = AuthService()
        let deviceUserDisplayName = auth.getUserDisplayName()
        guard auth.isLoggedIn(), let deviceUserId = auth.getUserId() else {
            return nil
        }

        self.updater = FirebaseUpdaterDelegate()
        self.listener = FirebaseListenerDelegate(lobbyId: self.id)

        updater?.managedLobby = self
        listener?.managedLobby = self

        joinLobby(userId: deviceUserId, userDisplayName: deviceUserDisplayName)
    }

    private func createLobby(hostId: EntityID, hostDisplayName: String) {
        updater?.createLobby(hostId: hostId, hostDisplayName: hostDisplayName)
    }

    private func joinLobby(userId: EntityID, userDisplayName: String) {
        updater?.joinLobby(userId: userId, userDisplayName: userDisplayName)
    }

    // MARK: - Callbacks
    func onLobbyConnectionOpen() {
        lobbyState = .matchmaking
        onLobbyStateChange?(.matchmaking)
    }

    func onLobbyConnectionClosed() {
        lobbyState = .disconnected
        onLobbyStateChange?(.disconnected)
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
            onLobbyDataChange?()
            return
        }

        users.append(user)
        onLobbyDataChange?()
    }

    func onUserUpdate(_ user: LobbyUser) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            return
        }

        users[index] = user
        onLobbyDataChange?()
        processLobbyUpdate()
    }

    func onUserRemove(_ userId: EntityID) {
        guard users.contains(where: { $0.id == userId }) else {
            return
        }

        users = users.filter { $0.id != userId }
        onLobbyDataChange?()

        if userId == hostId {
            onLobbyConnectionClosed()
        }
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

        updater?.toggleReady(userId: deviceUser.id)
    }

    private func processLobbyUpdate() {
        guard
            isLobbyFinalized,
            let lastUpdatedUser = users.max(by: { a, b in a.lastUpdatedAt < b.lastUpdatedAt })
        else {
            return
        }

        if synchronizer != nil {
            synchronizer?.updateSynchronizer(serverTimeMillis: lastUpdatedUser.lastUpdatedAt)
        } else {
            synchronizer = Synchronizer(serverTimeMillis: lastUpdatedUser.lastUpdatedAt)
        }

        if let currState = lobbyState, currState == .matchmaking {
            lobbyState = .gameInProgress
            onLobbyStateChange?(.gameInProgress)
        }
    }
}
