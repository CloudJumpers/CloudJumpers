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

    static func generateLobbyId() -> NetworkID {
        UUID().uuidString
    }

    static func generateLobbyName() -> String {
        // feel free to edit
        let availableNames = [
            "Cloud Jumpers",
            "Ascension",
            "Anti-Gravity",
            "Leap of Faith",
            "Stargazers",
            "Bird's Eye View",
            "Sky High",
            "Cloud Nine",
            "Horizon",
            "No Parachutes Allowed"
        ]

        guard let choice = availableNames.randomElement() else {
            fatalError("Missing options for lobby name")
        }

        return choice
    }
}
