//
//  LobbyListing.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

struct LobbyListing {
    let lobbyId: NetworkID
    let hostId: NetworkID
    let lobbyName: String
    let gameMode: GameMode
    let occupancy: Int
}
