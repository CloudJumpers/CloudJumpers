//
//  GameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

protocol GameEngine {
    var entitiesManager: EntitiesManager { get }
    var eventManager: EventManager { get }
    var touchableManager: TouchableManager { get }

    func update(_ deltaTime: Double)

}
