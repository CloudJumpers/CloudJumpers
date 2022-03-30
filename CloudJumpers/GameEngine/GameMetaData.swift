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
    var playerPosition = PositionConstants.playerInitialPosition
    var playerTexture = Textures.Kind.idle
    var playerLocationMapping = [EntityID: EntityID]()
    var topPlatformId = EntityID()
}
