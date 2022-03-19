//
//  LobbyConnectorDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

import Foundation

protocol LobbyConnectorDelegate: AnyObject {
    func createLobby() -> EntityID

    func joinLobby(lobbyId: EntityID)

    func exitLobby(lobbyId: EntityID, deleteLobby: Bool)

    func toggleReady(lobbyId: EntityID)
}
