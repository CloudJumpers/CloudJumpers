//
//  PowerUpEffect.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

class PowerUpEffect: Entity {
    let id: EntityID

    private var type: PowerUpType
    private var position: CGPoint

    init(at position: CGPoint, type: PowerUpType, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.type = type
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let timedComponent = createTimedComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(timedComponent, to: self)
    }

    func shouldRemoveEffect(manager: EntityManager) -> Bool {
        guard let timedComponent = manager.component(ofType: TimedComponent.self, of: self)
        else {
            return false
        }

        return timedComponent.time >= Constants.powerUpEffectDuration
    }

    private func createSpriteComponent() -> SpriteComponent {
        let node = SKSpriteNode(
            texture: SKTexture(imageNamed: "\(type)Effect"),
            size: Constants.powerUpEffectSize)
        node.position = position
        node.zPosition = SpriteZPosition.powerUp.rawValue

        return SpriteComponent(node: node, forEntityWith: id)
    }

    private func createTimedComponent() -> TimedComponent {
        TimedComponent(time: 0.0)
    }
}
