//
//  LobbyManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseLobbyConnectorDelegate: LobbyConnectorDelegate {
    func createLobby() -> EntityID {
        let userId = getActiveUserId()
        let userDisplayName = getActiveUserDisplayName()

        let lobbyId = LobbyUtils.generateLobbyId()
        let lobbyName = LobbyUtils.generateLobbyName()

        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        ref.onDisconnectRemoveValue() // When the host disconnects, the lobby closes

        ref.setValue([
            LobbyKeys.hostId: userId,
            LobbyKeys.lobbyName: lobbyName,
            LobbyKeys.participants: [
                userId: [
                    LobbyKeys.participantReady: false,
                    LobbyKeys.participantName: userDisplayName
                ]
            ]
        ])

        return lobbyId
    }

    func joinLobby(lobbyId: EntityID) {
        let userId = getActiveUserId()
        let userDisplayName = getActiveUserDisplayName()

        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        let participantsRef = ref.child(LobbyKeys.participants)

        // JoinLobby needs to be wrapped in a transaction, as the join requires the following conditions
        // - the lobby exists when the user joins
        // - user is not (somehow) in the lobby already
        // - the maximum occupancy is not reached
        participantsRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if
                currentData.childrenCount < LobbyConstants.MaxSupportedPlayers,
                var nextData = currentData.value as? [String: AnyObject],
                nextData[userId] == nil
            {
                nextData[userId] = ([
                    LobbyKeys.participantReady: false,
                    LobbyKeys.participantName: userDisplayName
                ]) as AnyObject?
                currentData.value = nextData

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            print("committed \(committed)")
            if let err = error {
                print("joinLobby error: \(err.localizedDescription)")
            }

            if let snap = snapshot {
                print("joinLobby snap: \(snap)")
            }
        }
    }

    func exitLobby(lobbyId: EntityID) {
        let userId = getActiveUserId()

        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        let participantsRef = ref.child(LobbyKeys.participants).child(userId)

        participantsRef.removeValue()
        participantsRef.removeAllObservers()
        ref.removeAllObservers()
    }

    private func constructLobbyPath(lobbyId: EntityID) -> String {
        "/\(LobbyKeys.root)/\(lobbyId)"
    }

    private func getActiveUserId() -> EntityID {
        guard let userId = AuthService().getUserId() else {
            fatalError("Expected user to be logged in.")
        }

        return userId
    }

    private func getActiveUserDisplayName() -> String {
        AuthService().getUserDisplayName()
    }
}
