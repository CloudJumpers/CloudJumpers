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

        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
        ref.onDisconnectRemoveValue()

        ref.observeSingleEvent(of: .value) { _ in
            ref.setValue([
                LobbyKeys.hostName: userId,
                LobbyKeys.lobbyName: lobbyName
            ])

            let participantSubRef = ref.child(LobbyKeys.participants).childByAutoId()
            participantSubRef.setValue([
                LobbyKeys.participantId: userId,
                LobbyKeys.participantReady: false
            ])
        }
    }

//    func joinLobby(userId: EntityID, lobbyId: EntityID) {
//        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
//
//        ref.observeSingleEvent(of: .value) { _ in
//            let participationRef = ref.child("participants").childByAutoId()
//            participationRef.child("id").setValue(userId)
//            participationRef.child("ready").setValue(false)
//        }
//    }
//
//    func leaveLobby(userId: UUID, lobbyId: EntityID) {
//        let ref = Database.database().reference(withPath: constructLobbyPath(lobbyId: lobbyId))
//
//        ref.observeSingleEvent(of: .value) { snapshot in
//            guard snapshot.exists() else {
//                return
//            }
//
//            ref.removeAllObservers()
//            ref.removeValue()
//        }
//    }

    private func constructLobbyPath(lobbyId: EntityID) -> String {
        "/\(LobbyKeys.root)/\(lobbyId)"
    }
}
