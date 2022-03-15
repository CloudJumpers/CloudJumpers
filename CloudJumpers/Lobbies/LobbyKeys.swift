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
    static let hostName = "host"
    static let lobbyName = "name"
    static let participants = "participants"

    // root/{lobbyid}/participants/{userid}/*
    static let participantReady = "ready"
}
