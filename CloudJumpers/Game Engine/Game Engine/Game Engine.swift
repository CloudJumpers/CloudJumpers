//
//  Game Engine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

protocol GameEngine {
    var entities: Set<GameEntity> { get set }

    var stateEntities: Set<StateEntity> { get set }

    func update(_ deltaTime: Double)

}
