//
//  GameConstants.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation

enum GameConstants {
    static let positionalUpdateIntervalTicks = 6
    static let shadowPlayerID = "shadow1234567890"
    static let shadowPlayerStartDelay = Double(LobbyConstants.gameStartDelayMillis) / 1_000
    static let shadowOpacity = 0.35
}
