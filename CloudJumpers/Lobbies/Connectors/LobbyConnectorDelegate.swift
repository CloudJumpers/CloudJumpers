//
//  LobbyConnectorDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

import Foundation

protocol LobbyConnectorDelegate: AnyObject {
    func createLobby(userId: EntityID) -> EntityID

    func joinLobby(userId: EntityID, lobbyId: EntityID)

    func exitLobby(userId: EntityID, lobbyId: EntityID)
}
