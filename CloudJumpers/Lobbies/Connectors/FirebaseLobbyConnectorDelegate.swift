//
//  LobbyManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseLobbyConnectorDelegate: LobbyConnectorDelegate {
    func createLobby(userId: EntityID) -> EntityID {
        let lobbyId = LobbyUtils.generateLobbyId()
        let lobbyName = LobbyUtils.generateLobbyName()

        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        ref.onDisconnectRemoveValue() // When the host disconnects, the lobby closes

        ref.setValue([
            LobbyKeys.hostName: userId,
            LobbyKeys.lobbyName: lobbyName,
            LobbyKeys.participants: [
                userId: [
                    LobbyKeys.participantReady: false
                ]
            ]
        ])

        return lobbyId
    }

    func joinLobby(userId: EntityID, lobbyId: EntityID) {
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
                nextData[userId] = ([ LobbyKeys.participantReady: false ]) as AnyObject?
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

    func exitLobby(userId: EntityID, lobbyId: EntityID) {
        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        let participantsRef = ref.child(LobbyKeys.participants).child(userId)

        participantsRef.removeValue()
        participantsRef.removeAllObservers()
        ref.removeAllObservers()
    }

    private func constructLobbyPath(lobbyId: EntityID) -> String {
        "/\(LobbyKeys.root)/\(lobbyId)"
    }
}
