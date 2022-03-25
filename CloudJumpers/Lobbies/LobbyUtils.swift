//
//  LobbyUtils.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import Foundation

class LobbyUtils {
    static func getUnixTimestampMillis() -> Int {
        Int(Date().timeIntervalSince1970 * 1_000)
    }

    static func generateLobbyId() -> EntityID {
        UUID().uuidString
    }

    static func generateLobbyName() -> String {
        "Cloud Jumpers"
    }
}
