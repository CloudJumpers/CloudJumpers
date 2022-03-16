//
//  GameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Combine
import SpriteKit

protocol GameEngine {
    var entitiesManager: EntitiesManager { get }
    var eventManager: EventManager { get }
    var touchableManager: TouchableManager { get }
    var addNodePublisher: AnyPublisher<SKNode, Never> { get }
    var removeNodePublisher: AnyPublisher<SKNode, Never> { get }

    func update(_ deltaTime: Double)

}
