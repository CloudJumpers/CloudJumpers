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

        let lobbyReference = getLobbyReference(lobbyId: lobbyId)
        lobbyReference.onDisconnectRemoveValue() // When the host disconnects, the lobby closes

        lobbyReference.setValue([
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

        let participantsReference = getLobbyParticipantsReference(lobbyId: lobbyId)

        // joinLobby needs to be wrapped in a transaction, as the join requires the following conditions
        // - the lobby exists when the user joins
        // - user is not (somehow) in the lobby already
        // - the maximum occupancy is not reached
        participantsReference.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
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

    func exitLobby(lobbyId: EntityID, deleteLobby: Bool = false) {
        let userReference = getLobbyUserReference(lobbyId: lobbyId)
        let lobbyReference = getLobbyReference(lobbyId: lobbyId)

        userReference.removeValue()
        userReference.removeAllObservers()

        lobbyReference.removeAllObservers()
        if deleteLobby {
            lobbyReference.removeValue()
        }
    }

    func toggleReady(lobbyId: EntityID) {
        let userId = getActiveUserId()
        let participantsReference = getLobbyParticipantsReference(lobbyId: lobbyId)

        // setReady requires the following:
        // - the lobby exists
        // - the user exists in the lobby
        // - the user was previously not ready
        participantsReference.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if
                var data = currentData.value as? [String: AnyObject],
                var userState = data[userId] as? [String: AnyObject],
                let userWasReady = userState[LobbyKeys.participantReady] as? Bool
            {
                userState[LobbyKeys.participantReady] = !userWasReady as AnyObject?
                data[userId] = userState as AnyObject?
                currentData.value = data

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, _, _ in
            if let err = error {
                print("readyLobby error: \(err.localizedDescription)")
            }
        }
    }

    private func constructLobbyPath(lobbyId: EntityID) -> String {
        "/\(LobbyKeys.root)/\(lobbyId)"
    }

    private func getLobbyReference(lobbyId: EntityID) -> DatabaseReference {
        Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
    }

    private func getLobbyParticipantsReference(lobbyId: EntityID) -> DatabaseReference {
        let lobbyReference = getLobbyReference(lobbyId: lobbyId)
        return lobbyReference.child(LobbyKeys.participants)
    }

    private func getLobbyUserReference(lobbyId: EntityID) -> DatabaseReference {
        let userId = getActiveUserId()
        return getLobbyParticipantsReference(lobbyId: lobbyId).child(userId)
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
