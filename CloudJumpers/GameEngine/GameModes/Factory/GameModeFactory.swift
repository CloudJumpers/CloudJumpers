//
//  GameModeFactory.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

class GameModeFactory {
    static let availableGameModes: [GameMode.Type] = [
        TimeTrial.self,
        RaceToTop.self
    ]

    static func createGameMode(name: String) -> GameMode {
        for gameModeOption in availableGameModes {
            let mode = gameModeOption.init()
            if mode.doesMatch(name) {
                return mode
            }
        }

        fatalError("Unable to find a matching game mode for name=\(name)")
    }

    static func getCompatibleModeNames(_ occupancy: Int) -> [String] {
        var names = [String]()

        availableGameModes.forEach {
            let mode = $0.init()

            if mode.maximumPlayers >= occupancy {
                names.append(mode.name)
            }
        }

        return names
    }
}
