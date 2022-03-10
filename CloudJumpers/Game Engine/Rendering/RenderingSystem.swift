//
//  RenderingSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/10/22.
//

import Foundation
import SpriteKit

class RenderingSystem: System {
    let componentDict: [GameEntity:RenderingComponent] = [:]
    let nodeEntityMapping: [GameEntity:SKNode] = [:]
    
    weak var gameScene: GameScene?
    
    init (gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    func addComponent(entity: GameEntity, component: Component) {
        guard let renderingComponent = component as? RenderingComponent else {
            return
        }
        let newNode = NodeFactory.createSpriteNode(from: renderingComponent)
        gameScene?.addChild(newNode)
    }
    
    func removeComponent(entity: GameEntity) {
        // remove here
    }
    
    func update(_ deltaTime: Double) {
        // Update game physics
    }
}
