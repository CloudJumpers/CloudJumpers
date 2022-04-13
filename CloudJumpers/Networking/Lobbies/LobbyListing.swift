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
    let config: PreGameConfig
    let occupancy: Int
    let isOpen: Bool
}
