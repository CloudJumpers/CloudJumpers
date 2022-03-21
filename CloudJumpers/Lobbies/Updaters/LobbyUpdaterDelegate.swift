//
//  UpdaterDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

protocol LobbyUpdaterDelegate: AnyObject {
    var managedLobby: NetworkedLobby? { get set }

    func createLobby(hostId: EntityID, hostDisplayName: String)
    func joinLobby(userId: EntityID, userDisplayName: String)
    func exitLobby(userId: EntityID, deleteLobby: Bool)
    func toggleReady(userId: EntityID)
}
