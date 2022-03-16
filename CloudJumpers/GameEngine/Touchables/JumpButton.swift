//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import CoreGraphics

class JumpButton: Touchable, Renderable {
    var renderingComponent: RenderingComponent
    var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.renderingComponent = RenderingComponent(type: .button,
                                                     position: Constants.jumpButtonPosition,
                                                     name: Constants.jumpButtonImage,
                                                     size: Constants.jumpButtonSize)
        self.associatedEntity = associatedEntity
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        guard renderingComponent.contains(touchLocation) else {
            return nil
        }
        return Input(inputType: .jump(entity: associatedEntity))

    }

    func activate(renderingSystem: RenderingSystem) {
        let entity = Entity(type: .button)
        renderingSystem.addComponent(entity: entity,
                                     component: renderingComponent)
    }
}
