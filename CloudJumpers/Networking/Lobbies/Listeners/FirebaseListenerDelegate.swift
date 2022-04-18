//
//  FirebaseListenerDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import FirebaseDatabase

private typealias firebaseStructure = [String: Any]

class FirebaseListenerDelegate: LobbyListenerDelegate {
    weak var managedLobby: NetworkedLobby?

    private var connectedRef: DatabaseReference
    private var lobbyRef: DatabaseReference
    private var lobbyUsersRef: DatabaseReference

    init(lobbyId: NetworkID) {
        self.connectedRef = Database.database().reference(withPath: LobbyKeys.isConnected)
        self.lobbyRef = Database.database().reference(withPath: LobbyKeys.root).child(lobbyId)
        self.lobbyUsersRef = lobbyRef.child(LobbyKeys.participants)

        setUpListeners()
    }

    deinit {
        tearDownListeners()
    }

    private func setUpListeners() {
        setUpUserAddListener()
        setUpUserUpdateListener()
        setUpUserRemoveListener()
        setUpNameListener()
        setUpGameModeListener()
        setUpHostListener()
        setUpSeedListener()
        setUpConnectionListener()
    }

    private func setUpUserAddListener() {
        lobbyUsersRef.observe(.childAdded) { snapshot in
            self.handleAddUpdate(snapshot: snapshot)
        }
    }

    private func setUpUserUpdateListener() {
        lobbyUsersRef.observe(.childChanged) { snapshot in
            self.handleChangeUpdate(snapshot: snapshot)
        }
    }

    private func setUpUserRemoveListener() {
        lobbyUsersRef.observe(.childRemoved) { snapshot in
            self.handleRemoveUpdate(snapshot: snapshot)
        }
    }

    private func setUpNameListener() {
        lobbyRef.child(LobbyKeys.lobbyName).observe(.value) { snapshot in
            guard let newName = snapshot.value as? String else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onNameChange(newName)
        }
    }

    private func setUpGameModeListener() {
        lobbyRef.child(LobbyKeys.gameMode).observe(.value) { snapshot in
            guard let name = snapshot.value as? String else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            let newGameMode = GameModeFactory.createGameMode(name: name)
            self.managedLobby?.onGameModeChange(newGameMode)
        }
    }

    private func setUpHostListener() {
        lobbyRef.child(LobbyKeys.hostId).observe(.value) { snapshot in
            guard let newHost = snapshot.value as? NetworkID else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onHostChange(newHost)
        }
    }

    private func setUpSeedListener() {
        lobbyRef.child(LobbyKeys.gameSeed).observe(.value) { snapshot in
            guard let newSeed = snapshot.value as? Int else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onGameSeedChange(newSeed)
        }
    }

    private func setUpConnectionListener() {
        connectedRef.observe(.value) { snapshot in
            guard let isConnected = snapshot.value as? Bool, isConnected else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }
        }
    }

    private func handleAddUpdate(snapshot: DataSnapshot) {
        managedLobby?.onUserAdd(unpackUser(snapshot))
    }

    private func handleChangeUpdate(snapshot: DataSnapshot) {
        managedLobby?.onUserUpdate(unpackUser(snapshot))
    }

    private func handleRemoveUpdate(snapshot: DataSnapshot) {
        managedLobby?.onUserRemove(unpackUser(snapshot).id)
    }

    private func unpackUser(_ snapshot: DataSnapshot) -> LobbyUser {
        guard
            let userData = snapshot.value as? firebaseStructure,
            let displayName = userData[LobbyKeys.participantName] as? String,
            let isReady = userData[LobbyKeys.participantReady] as? Bool,
            let lastUpdatedAt = userData[LobbyKeys.participantLastUpdatedAt] as? Int
        else {
            fatalError("Unexpected data structure encountered during unpack \(snapshot)")
        }

        let userId = snapshot.key
        return LobbyUser(id: userId, displayName: displayName, lastUpdatedAt: lastUpdatedAt, isReady: isReady)
    }

    private func tearDownListeners() {
        lobbyRef.removeAllObservers()
        lobbyUsersRef.removeAllObservers()
    }
}
