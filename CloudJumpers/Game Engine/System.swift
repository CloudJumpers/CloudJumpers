//
//  System.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

protocol System {
    func update(_ deltaTime: Double)
    func addComponent(entity: GameEntity, component: Component)
    func removeComponent(entity: GameEntity)
}
