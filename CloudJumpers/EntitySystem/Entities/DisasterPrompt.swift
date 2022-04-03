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

    init(_ kind: DisasterComponent.Kind, at position: CGPoint,
         with id: EntityID = EntityManager.newEntityID) {

        self.id = id
        self.kind = kind
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        manager.addComponent(spriteComponent, to: self)

        let timedComponent = createTimedComponent()
        manager.addComponent(timedComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let node = SKSpriteNode(
            texture: SKTexture(imageNamed: "\(kind)Prompt"),
            size: Constants.disasterPromptSize)

        node.position = position
        node.zPosition = SpriteZPosition.disaster.rawValue
        node.alpha = 0
        node.anchorPoint = CGPoint(x: 0.5, y: 0)

        return SpriteComponent(node: node, forEntityWith: id)
    }

    private func createTimedComponent() -> TimedComponent {
        TimedComponent()
    }
}
