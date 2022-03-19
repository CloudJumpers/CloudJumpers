//
//  FirebaseListenerDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import FirebaseDatabase

private typealias firebaseStructure = [String: Any]

class FirebaseListenerDelegate: ListenerDelegate {
    var onUserAdd: UserCallback
    var onUserChange: UserCallback
    var onUserRemove: UserCallback
    var onLobbyChange: StringKeyValCallback

    private var lobbyRef: DatabaseReference
    private var lobbyUsersRef: DatabaseReference

    init(
        lobbyId: EntityID,
        onUserAdd: UserCallback,
        onUserChange: UserCallback,
        onUserRemove: UserCallback,
        onLobbyChange: StringKeyValCallback
    ) {
        self.lobbyRef = Database.database().reference(withPath: LobbyKeys.root).child(lobbyId)
        self.lobbyUsersRef = lobbyRef.child(LobbyKeys.participants)

        self.onUserAdd = onUserAdd
        self.onUserChange = onUserChange
        self.onUserRemove = onUserRemove
        self.onLobbyChange = onLobbyChange

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
                return
            }
            self.onLobbyChange?(snapshot.key, newName)
        }

        lobbyRef.child(LobbyKeys.gameMode).observe(.value) { snapshot in
            guard let newGameMode = snapshot.value as? String else {
                return
            }
            self.onLobbyChange?(snapshot.key, newGameMode)
        }
    }

    private func handleAddUpdate(snapshot: DataSnapshot) {
        onUserAdd?(unpackUser(snapshot))
    }

    private func handleChangeUpdate(snapshot: DataSnapshot) {
        onUserChange?(unpackUser(snapshot))
    }

    private func handleRemoveUpdate(snapshot: DataSnapshot) {
        onUserRemove?(unpackUser(snapshot))
    }

    private func unpackUser(_ snapshot: DataSnapshot) -> LobbyUser {
        guard
            let userData = snapshot.value as? firebaseStructure,
            let displayName = userData[LobbyKeys.participantName] as? String,
            let isReady = userData[LobbyKeys.participantReady] as? Bool
        else {
            fatalError("Unexpected data structure encountered during unpack \(snapshot)")
        }

        let userId = snapshot.key
        return LobbyUser(id: userId, displayName: displayName, isReady: isReady)
    }

    private func tearDownListeners() {
        lobbyRef.removeAllObservers()
        lobbyUsersRef.removeAllObservers()
    }
}
