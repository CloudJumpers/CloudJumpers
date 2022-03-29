//
//  AbstractGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import SpriteKit

protocol AbstractGameEngine: InputResponder {
    var entityManager: EntityManager { get }
    var eventManager: EventManager { get }
    var contactResolver: ContactResolver { get }
    var delegate: GameEngineDelegate? { get }
    var metaData: GameMetaData { get set }
    var systems: [System] { get set }

    init(for delegate: GameEngineDelegate, channel: NetworkID?)
    func setUpGame(with clouds: [Cloud], playerId: EntityID, additionalPlayerIds: [EntityID]?)
    func updatePlayer(with displacement: CGVector)
    func update(within time: CGFloat)
}
