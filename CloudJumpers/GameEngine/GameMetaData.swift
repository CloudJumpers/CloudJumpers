//
//  GameMetaData.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

class GameMetaData {
    var time: Double = 0
    var playerId = UUID()
    var playerLocationMapping = [UUID: UUID]()
    var topPlatformId = UUID()
}
