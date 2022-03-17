//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import CoreGraphics

class JumpButton: Entity, Touchable, Renderable {
    var renderingComponent = RenderingComponent(type: .button,
                                                position: Constants.jumpButtonPosition,
                                                name: Images.outerStick.name,
                                                size: Constants.jumpButtonSize)
    var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.associatedEntity = associatedEntity
        super.init(type: .button)
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        guard renderingComponent.contains(touchLocation) else {
            return nil
        }
        return Input(inputType: .jump(entity: associatedEntity))

    }

    func activate(renderingSystem: RenderingSystem) {
        renderingSystem.addComponent(entity: self, component: renderingComponent)
    }
}
