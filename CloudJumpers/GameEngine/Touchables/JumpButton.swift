//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import SpriteKit

class JumpButton: SKEntity, Touchable {
    var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.associatedEntity = associatedEntity
        super.init(type: .button)
        self.node = createSKNode()

    }

    override func createSKNode() -> SKNode? {
        let sprite = SKSpriteNode(imageNamed: Images.outerStick.name)
        sprite.position = Constants.jumpButtonPosition
        sprite.size = Constants.jumpButtonSize
        sprite.zPosition = SpriteZPosition.button.rawValue
        return sprite
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Event? {
        guard let node = self.node as? SKSpriteNode,
              touchLocation.isInside(position: node.position, size: node.size)
        else {
            return nil
        }
        return Event(type: .inputJump(entity: associatedEntity))
    }
}
