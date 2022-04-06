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
        setOnDisconnectRemove()

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
            if error == nil {
                lobby.onLobbyConnectionOpen()
                let participantsReference = self.getLobbyParticipantsReference(lobbyId: lobby.id)
                participantsReference.child(hostId).onDisconnectRemoveValue()
            } else {
                lobby.onLobbyConnectionClosed()
            }
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
            if currentData.childrenCount >= lobby.gameMode.getMaxPlayer() {
                return TransactionResult.abort()
            }

            if
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
        }) { error, committed, _ in
            if error == nil && committed {
                lobby.onLobbyConnectionOpen()
                participantsReference.child(userId).onDisconnectRemoveValue()
            } else {
                lobby.onLobbyConnectionClosed()
            }
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
            channelReference.onDisconnectRemoveValue()
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

        // e.g. setReady requires the following:
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

    func changeLobbyGameMode(to gameMode: GameMode) {
        guard let lobby = managedLobby else {
            return
        }

        let lobbyGameModeReference = getLobbyReference(lobbyId: lobby.id).child(LobbyKeys.gameMode)
        lobbyGameModeReference.setValue(gameMode.rawValue)
    }

    func changeLobbyName(to name: String) {
        guard let lobby = managedLobby else {
            return
        }

        let lobbyNameReference = getLobbyReference(lobbyId: lobby.id).child(LobbyKeys.lobbyName)
        lobbyNameReference.setValue(name)
    }

    /// All remaining devices independently arrive at the same new host,
    /// and attempt to update the host. A single device cannot be
    /// responsible for this update, as failure of this device will cause
    /// the remaining (n-2) devices to have an outdated hostId.
    func changeLobbyHost(to host: NetworkID) {
        guard let lobby = managedLobby else {
            return
        }

        let lobbyHostReference = getLobbyReference(lobbyId: lobby.id).child(LobbyKeys.hostId)

        lobbyHostReference.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let currHostOnRemote = currentData.value as? String {
                if currHostOnRemote != lobby.hostId {
                    // Device has outdated information, better for it to just listen to updates
                    return TransactionResult.abort()
                }

                currentData.value = host
            }

            return TransactionResult.success(withValue: currentData)
        }) { error, _, _ in
            if let err = error {
                print("error occurred during changeLobbyHost: \(err.localizedDescription)")
            }
        }
    }

    func setOnDisconnectRemove() {
        guard let lobby = managedLobby else {
            return
        }

        let reference = getLobbyReference(lobbyId: lobby.id)
        reference.onDisconnectRemoveValue()
    }

    func clearOnDisconnectRemove() {
        guard let lobby = managedLobby, let deviceUserId = AuthService().getUserId() else {
            return
        }

        let lobbyReference = getLobbyReference(lobbyId: lobby.id)
        let userReference = getLobbyUserReference(lobbyId: lobby.id, userId: deviceUserId)

        lobbyReference.cancelDisconnectOperations()
        userReference.onDisconnectRemoveValue()
    }

    private func getLobbyReference(lobbyId: NetworkID) -> DatabaseReference {
        Database.database().reference().child(LobbyKeys.root).child(lobbyId)
    }

    private func getLobbyParticipantsReference(lobbyId: NetworkID) -> DatabaseReference {
        let lobbyReference = getLobbyReference(lobbyId: lobbyId)
        return lobbyReference.child(LobbyKeys.participants)
    }

    private func getLobbyUserReference(lobbyId: NetworkID, userId: NetworkID) -> DatabaseReference {
        getLobbyParticipantsReference(lobbyId: lobbyId).child(userId)
    }

    private func getLobbyChannelReference(lobbyId: NetworkID) -> DatabaseReference {
        Database.database().reference().child(GameKeys.root).child(lobbyId)
    }
}
