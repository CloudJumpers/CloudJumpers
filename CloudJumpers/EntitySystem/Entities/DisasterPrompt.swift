//
//  DisasterPrompt.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import SpriteKit

class DisasterPrompt: Entity {
    let id: EntityID
    private var position: CGPoint
    private let kind: DisasterComponent.Kind
    private let intervalToRemove: TimeInterval

    init(_ kind: DisasterComponent.Kind,
         at position: CGPoint,
         intervalToRemove: TimeInterval,
         with id: EntityID = EntityManager.newEntityID
    ) {

        self.id = id
        self.kind = kind
        self.position = position
        self.intervalToRemove = intervalToRemove
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        manager.addComponent(spriteComponent, to: self)

        manager.addComponent(TimedComponent(), to: self)
        manager.addComponent(TimedRemovalComponent(timeToRemove: intervalToRemove), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: Miscellaneous.meteorPrompt.frame,
            size: Constants.disasterPromptSize,
            zPosition: .disaster)

        spriteComponent.alpha = 0.0
        spriteComponent.anchorPoint = CGPoint(x: 0.5, y: 0)

        return spriteComponent
    }
}
