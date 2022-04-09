//
//  FirebaseListenerDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import FirebaseDatabase

private typealias firebaseStructure = [String: Any]

class FirebaseListenerDelegate: ListenerDelegate {
    weak var managedLobby: NetworkedLobby?

    private var lobbyRef: DatabaseReference
    private var lobbyUsersRef: DatabaseReference

    init(lobbyId: NetworkID) {
        self.lobbyRef = Database.database().reference(withPath: LobbyKeys.root).child(lobbyId)
        self.lobbyUsersRef = lobbyRef.child(LobbyKeys.participants)

        setUpListeners()
    }

    deinit {
        tearDownListeners()
    }

    private func setUpListeners() {
        lobbyUsersRef.observe(.childAdded) { snapshot in
            self.handleAddUpdate(snapshot: snapshot)
        }

        lobbyUsersRef.observe(.childChanged) { snapshot in
            self.handleChangeUpdate(snapshot: snapshot)
        }

        lobbyUsersRef.observe(.childRemoved) { snapshot in
            self.handleRemoveUpdate(snapshot: snapshot)
        }

        lobbyRef.child(LobbyKeys.lobbyName).observe(.value) { snapshot in
            guard let newName = snapshot.value as? String else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onNameChange(newName)
        }

        lobbyRef.child(LobbyKeys.gameMode).observe(.value) { snapshot in
            guard
                let newGameModeString = snapshot.value as? String,
                let newGameMode = OldGameMode(rawValue: newGameModeString)
            else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onGameModeChange(newGameMode)
        }

        lobbyRef.child(LobbyKeys.hostId).observe(.value) { snapshot in
            guard let newHost = snapshot.value as? NetworkID else {
                self.managedLobby?.onLobbyConnectionClosed()
                return
            }

            self.managedLobby?.onHostChange(newHost)
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
