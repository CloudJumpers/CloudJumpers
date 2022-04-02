//
//  GameMetaData.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

class GameMetaData {
    var time = Double.zero
    var playerId = EntityID()
    var playerPosition = Constants.playerInitialPosition
    var playerStartingPosition = Constants.playerInitialPosition
    var playerTexture = Textures.Kind.idle
    var locationMapping = [EntityID: (location:EntityID, time: TimeInterval)]()
    var highestPosition = Constants.defaultPosition
    var topPlatformId = EntityID()
}
