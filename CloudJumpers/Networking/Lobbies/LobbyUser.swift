//
//  LobbyUser.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

struct LobbyUser: IdentifiableByNetworkID {
    let id: NetworkID
    let displayName: String

    let isReady: Bool
    let lastUpdatedAt: Int

    init(id: NetworkID, displayName: String, lastUpdatedAt: Int, isReady: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.isReady = isReady
        self.lastUpdatedAt = lastUpdatedAt
    }
}

extension LobbyUser: Equatable {
}
