//
//  Lobby.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 21/3/22.
//

import Foundation

protocol NetworkedLobby: AnyObject {
    var id: EntityID { get }
    var name: String { get }
    var gameMode: GameMode { get }

    var hostId: EntityID { get }
    var userIsHost: Bool { get }

    var users: [LobbyUser] { get }
    var numUsers: Int { get }

    func onUserAdd(_ user: LobbyUser)
    func onUserUpdate(_ user: LobbyUser)
    func onUserRemove(_ userId: EntityID)
    func onGameModeChange(_ newGameMode: GameMode)
    func onNameChange(_ newName: String)

    func toggleDeviceUserReadyStatus()

    // events
    func onLobbyConnectionOpen()
    func onLobbyConnectionClosed()
}
