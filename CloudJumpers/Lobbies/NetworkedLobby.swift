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

    var onLobbyStateChange: LobbyCallback? { get set }
    var updaterDelegate: LobbyUpdaterDelegate? { get set }
    var listenerDelegate: ListenerDelegate? { get set }

    func onAddUser(_ user: LobbyUser)
    func onUpdateUser(_ user: LobbyUser)
    func onRemoveUser(_ userId: EntityID)

    func toggleDeviceUserReadyStatus()

    // events
    func onLobbyConnectionOpen()
    func onLobbyConnectionClosed()
}
