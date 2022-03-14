//
//  LobbyUtils.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

class LobbyUtils {
    static func getUnixTimestampSeconds() -> Int {
        Int(Date().timeIntervalSince1970)
    }

    static func generateLobbyId() -> EntityID {
        UUID().uuidString
    }
}
