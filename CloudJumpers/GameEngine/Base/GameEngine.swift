//
//  GameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import SpriteKit

protocol GameEngine: AnyObject {
    var entitiesManager: EntitiesManager { get }
    var eventManager: EventManager { get }
    var touchableManager: TouchableManager { get }
    var contactResolver: ContactResolver { get }
    var delegate: GameEngineDelegate? { get set }

    func setupGame(with level: Level)
    func update(_ deltaTime: Double)
}
