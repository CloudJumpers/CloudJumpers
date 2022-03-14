//
//  PlayerComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation
import CoreGraphics

class PlayerComponent: Component, Renderable {
    var location: Location
    var renderingComponent: RenderingComponent
    
    init(position: CGPoint, location: Location = .start) {
        self.location = location
        self.renderingComponent = RenderingComponent(type: .sprite,
                                                     position: position,
                                                     name: Constants.playerImage,
                                                     size: Constants.playerSize)
    }
    
    func activate(renderingSystem: RenderingSystem) -> Entity {
        let playerEntity = Entity(type: .player)
        renderingSystem.addComponent(entity: playerEntity, component: renderingComponent)
        
        return playerEntity
    }
    
    enum Location {
        case start, air,cloud(entity:Entity),platform(entity:Entity)
    }
}
