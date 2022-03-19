//
//  LobbyUser.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

struct LobbyUser: NetworkedEntity {
    let id: EntityID
    let displayName: String

    private(set) var isReady: Bool
    private(set) var lastUpdatedAt: Int

    init(id: EntityID, displayName: String, isReady: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.isReady = isReady
        self.lastUpdatedAt = LobbyUtils.getUnixTimestampSeconds()
    }

    @available(*, unavailable)
    func isUpdatable() -> Bool {
        let currentTime = LobbyUtils.getUnixTimestampSeconds()
        return (currentTime - lastUpdatedAt) > LobbyConstants.minUpdateInterval
    }

    mutating func setAsReady() {
        isReady = true
        refreshLastUpdatedAt()
    }

    mutating func setAsNotReady() {
        isReady = false
        refreshLastUpdatedAt()
    }

    private mutating func refreshLastUpdatedAt() {
        lastUpdatedAt = LobbyUtils.getUnixTimestampSeconds()
    }
}
