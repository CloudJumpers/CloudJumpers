//
//  LobbyKeys.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

enum LobbyKeys {
    static let root = "lobbies"

    // root/{lobbyid}/*
    static let hostId = "host"
    static let lobbyName = "name"
    static let gameSeed = "gameseed"
    static let gameMode = "gamemode"
    static let participants = "participants"

    // root/{lobbyid}/participants/{userid}/*
    static let participantName = "name"
    static let participantReady = "ready"
    static let participantLastUpdatedAt = "updatedAt"
}
