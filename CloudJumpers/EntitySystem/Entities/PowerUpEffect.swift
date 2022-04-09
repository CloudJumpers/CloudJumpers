//
//  PowerUpEffect.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

class PowerUpEffect: Entity {
    let id: EntityID

    private var position: CGPoint
    private var kind: PowerUpComponent.Kind
    private let intervalToRemove: TimeInterval


    init(_ kind: PowerUpComponent.Kind,
         at position: CGPoint,
         intervalToRemove: TimeInterval,
         with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.kind = kind
        self.position = position
        self.intervalToRemove = intervalToRemove
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let timedComponent = createTimedComponent()
        let timedRemovalComponent = createRemoveComponent()
        manager.addComponent(timedRemovalComponent, to: self)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(timedComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let node = SKSpriteNode(
            texture: SKTexture(imageNamed: "\(kind)Effect"),
            size: Constants.powerUpEffectSize)

        node.position = position
        node.zPosition = SpriteZPosition.powerUpEffect.rawValue

        return SpriteComponent(node: node, forEntityWith: id)
    }

    private func createTimedComponent() -> TimedComponent {
        TimedComponent()
    }
    
    private func createRemoveComponent() -> TimedRemovalComponent {
        TimedRemovalComponent(timeToRemove: intervalToRemove)
    }
}
