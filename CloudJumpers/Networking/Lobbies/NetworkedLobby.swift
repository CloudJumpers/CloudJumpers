//
//  Lobby.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 21/3/22.
//

import Foundation

protocol NetworkedLobby: AnyObject {
    var id: NetworkID { get }
    var name: String { get }
    var gameMode: OldGameMode { get }

    var hostId: NetworkID { get }
    var userIsHost: Bool { get }

    var users: [LobbyUser] { get }
    var numUsers: Int { get }

    func onUserAdd(_ user: LobbyUser)
    func onUserUpdate(_ user: LobbyUser)
    func onUserRemove(_ userId: NetworkID)
    func onGameModeChange(_ newGameMode: OldGameMode)
    func onNameChange(_ newName: String)
    func onHostChange(_ newHostId: NetworkID)

    func toggleDeviceUserReadyStatus()

    // events
    func onLobbyConnectionOpen()
    func onLobbyConnectionClosed()
}
