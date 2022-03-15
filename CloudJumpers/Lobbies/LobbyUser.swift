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

    init(id: EntityID, displayName: String) {
        self.id = id
        self.displayName = displayName
        self.isReady = false
        self.lastUpdatedAt = LobbyUtils.getUnixTimestampSeconds()
    }

    func isUpdatable() -> Bool {
        let currentTime = LobbyUtils.getUnixTimestampSeconds()
        return (currentTime - lastUpdatedAt) > LobbyConstants.minUpdateInterval
    }

    /// toggleReady checks whether an update can be performed,
    /// and toggles the ready state of the lobby user
    ///
    /// Returns the new readiness of the lobby user.
    mutating func toggleReady() -> Bool {
        guard isUpdatable() else {
            return isReady
        }

        isReady.toggle()
        refreshLastUpdatedAt()
        return isReady
    }

    private mutating func refreshLastUpdatedAt() {
        lastUpdatedAt = LobbyUtils.getUnixTimestampSeconds()
    }
}
