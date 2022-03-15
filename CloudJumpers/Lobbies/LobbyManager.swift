//
//  LobbyManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation
import FirebaseDatabase

class LobbyManager {
    func createLobby(userId: EntityID) {
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
    }

    func joinLobby(userId: EntityID, lobbyId: EntityID) {
        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        let participantsRef = ref.child(LobbyKeys.participants).childByAutoId()

        participantsRef.setValue([
            userId: [
                LobbyKeys.participantReady: false
            ]
        ])
    }

    func leaveLobby(userId: EntityID, lobbyId: EntityID) {
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
