//
//  GameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import SpriteKit

protocol GameEngine: InputResponder {
    var entityManager: EntityManager { get }
    var eventManager: EventManager { get }
    var contactResolver: ContactResolver { get }
    var delegate: GameEngineDelegate? { get }
    var systems: [System] { get set }

    init(for delegate: GameEngineDelegate, channel: EntityID?)
    func setUpGame()
    func update(within time: CGFloat)
}
