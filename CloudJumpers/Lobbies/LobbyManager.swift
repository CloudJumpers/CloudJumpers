//
//  LobbyManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation
import FirebaseDatabase

class LobbyManager {
    func createNewLobby(userId: EntityID) {
        let lobbyId = LobbyUtils.generateLobbyId()
        let lobbyName = LobbyUtils.generateLobbyName()

        let ref = Database.database().reference(withPath: "/lobbies/\(lobbyId)")
        ref.onDisconnectRemoveValue()

        ref.observeSingleEvent(of: .value) { _ in
            let store: NSDictionary = [
                "host": userId,
                "name": lobbyName
            ]

            ref.setValue(store)

            let participationRef = ref.child("participants").childByAutoId()
            participationRef.setValue([
                "id": userId,
                "ready": false
            ])
        }
    }

    func joinLobby(userId: EntityID, lobbyId: EntityID) {
        let ref = Database.database().reference(withPath: "/lobbies/\(lobbyId)")

        ref.observeSingleEvent(of: .value) { _ in
            let participationRef = ref.child("participants").childByAutoId()
            participationRef.child("id").setValue(userId)
            participationRef.child("ready").setValue(false)
        }
    }

    func leaveLobby(userId: UUID, lobbyId: UUID) {
        let ref = Database.database().reference(withPath: "/lobbies/\(lobbyId)")

        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                return
            }

            ref.removeAllObservers()
            ref.removeValue()
        }
    }
}
