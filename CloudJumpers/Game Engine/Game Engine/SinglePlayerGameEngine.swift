//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class SinglePlayerGameEngine: GameEngine {
    weak var gameScene: GameScene?
    
    var entities: Set<GameEntity> = []

    var stateEntities: Set<StateEntity> = []
    
    // System
    let renderingSystem: RenderingSystem
    let collisionSystem: CollisionSystem
    
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        renderingSystem = RenderingSystem(gameScene: gameScene)
        collisionSystem = CollisionSystem()
        
    }
    
    

    func update(_ deltaTime: Double) {
        // Update individual systems
    }

}
