//
//  FirebaseUpdaterDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseUpdaterDelegate: LobbyUpdaterDelegate {
    weak var managedLobby: NetworkedLobby?

    func createLobby(hostId: NetworkID, hostDisplayName: String) {
        guard let lobby = managedLobby else {
            return
        }

        let lobbyReference = getLobbyReference(lobbyId: lobby.id)
        lobbyReference.onDisconnectRemoveValue() // When the host disconnects, the lobby closes

        lobbyReference.setValue([
            LobbyKeys.hostId: hostId,
            LobbyKeys.lobbyName: lobby.name,
            LobbyKeys.gameMode: lobby.gameMode.rawValue,
            LobbyKeys.participants: [
                lobby.hostId: [
                    LobbyKeys.participantReady: false,
                    LobbyKeys.participantName: hostDisplayName,
                    LobbyKeys.participantLastUpdatedAt: ServerValue.timestamp()
                ]
            ]
        ]) { error, _ in
            error == nil ? lobby.onLobbyConnectionOpen() : lobby.onLobbyConnectionClosed()
        }
    }

    func joinLobby(userId: NetworkID, userDisplayName: String) {
        guard let lobby = managedLobby else {
            return
        }

        let participantsReference = getLobbyParticipantsReference(lobbyId: lobby.id)

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
                    LobbyKeys.participantName: userDisplayName,
                    LobbyKeys.participantLastUpdatedAt: ServerValue.timestamp()
                ]) as AnyObject?
                currentData.value = nextData

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, _, _ in
            error == nil ? lobby.onLobbyConnectionOpen() : lobby.onLobbyConnectionClosed()
        }
    }

    func exitLobby(userId: NetworkID, deleteLobby: Bool = false) {
        guard let lobby = managedLobby else {
            return
        }

        if deleteLobby {
            let lobbyReference = getLobbyReference(lobbyId: lobby.id)
            let channelReference = getLobbyChannelReference(lobbyId: lobby.id)
            lobbyReference.removeValue()
            channelReference.removeValue()
        } else {
            let userReference = getLobbyUserReference(lobbyId: lobby.id, userId: userId)
            userReference.removeValue()
        }
    }

    func toggleReady(userId: NetworkID) {
        guard let lobby = managedLobby else {
            return
        }

        let participantsReference = getLobbyParticipantsReference(lobbyId: lobby.id)

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
                userState[LobbyKeys.participantReady] = !userWasReady as AnyObject
                userState[LobbyKeys.participantLastUpdatedAt] = ServerValue.timestamp() as AnyObject
                data[userId] = userState as AnyObject?
                currentData.value = data

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, _, _ in
            if let err = error {
                print("error occurred during toggleReady: \(err.localizedDescription)")
            }
        }
    }

    private func constructLobbyPath(lobbyId: NetworkID) -> String {
        "/\(LobbyKeys.root)/\(lobbyId)"
    }

    private func getLobbyReference(lobbyId: NetworkID) -> DatabaseReference {
        Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
    }

    private func getLobbyParticipantsReference(lobbyId: NetworkID) -> DatabaseReference {
        let lobbyReference = getLobbyReference(lobbyId: lobbyId)
        return lobbyReference.child(LobbyKeys.participants)
    }

    private func getLobbyUserReference(lobbyId: NetworkID, userId: NetworkID) -> DatabaseReference {
        getLobbyParticipantsReference(lobbyId: lobbyId).child(userId)
    }

    private func getLobbyChannelReference(lobbyId: NetworkID) -> DatabaseReference {
        Database.database().reference(withPath: "\(GameKeys.root)/\(lobbyId)")
    }
}
