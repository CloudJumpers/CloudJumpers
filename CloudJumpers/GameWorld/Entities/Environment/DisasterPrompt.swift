//
//  DisasterPrompt.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

class DisasterPrompt: Entity {
    let id: EntityID
    private let position: CGPoint
    private let velocity: CGVector
    private let kind: DisasterComponent.Kind
    private let disasterTexture: Miscellaneous
    private let intervalToTransform: TimeInterval

    init(_ kind: DisasterComponent.Kind,
         at position: CGPoint,
         velocity: CGVector,
         disasterTexture: Miscellaneous,
         transformAfter intervalToTransform: TimeInterval,
         with id: EntityID = EntityManager.newEntityID
    ) {

        self.id = id
        self.kind = kind
        self.position = position
        self.velocity = velocity
        self.disasterTexture = disasterTexture
        self.intervalToTransform = intervalToTransform
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(PositionComponent(at: position), to: self)

        manager.addComponent(TimedComponent(), to: self)
        manager.addComponent(DisposableTag(), to: self)
        manager.addComponent(DisasterTransformComponent(kind: kind, position: position,
                                                        velocity: velocity, disasterTexture: disasterTexture,
                                                        after: intervalToTransform), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: Miscellaneous.meteorPrompt.frame,
            size: Dimensions.disasterPrompt,
            zPosition: .disaster)

        spriteComponent.anchorPoint = CGPoint(x: 0.5, y: 0)

        return spriteComponent
    }
}
