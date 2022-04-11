//
//  UpdaterDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

enum DeleteMode {
    case None
    case LobbyOnly
    case All
}

protocol LobbyUpdaterDelegate: AnyObject {
    var managedLobby: NetworkedLobby? { get set }

    func createLobby(hostId: NetworkID, hostDisplayName: String)
    func joinLobby(userId: NetworkID, userDisplayName: String)
    func exitLobby(userId: NetworkID, deleteLobby: DeleteMode)
    func toggleReady(userId: NetworkID)

    func changeLobbyGameMode(to gameMode: GameMode)
    func changeLobbyName(to name: String)
    func changeLobbyHost(to host: NetworkID)

    func setOnDisconnectRemove()
    func clearOnDisconnectRemove()
}
