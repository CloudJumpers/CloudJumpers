//
//  LobbyKeys.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

enum LobbyKeys {
    static let root = "lobbies"

    // root/{key}/*
    static let hostName = "host"
    static let lobbyName = "name"
    static let participants = "participants"

    // root/{key}/participants/*
    static let participantId = "id"
    static let participantReady = "ready"
}
