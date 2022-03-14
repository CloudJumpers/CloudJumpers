//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import Foundation
import CoreGraphics

class JumpButton: Touchable, Renderable {
    var renderingComponent: RenderingComponent
    var gameEngine: GameEngine
    var associatedEntity: Entity

    init(gameEngine: GameEngine, associatedEntity: Entity) {
        self.renderingComponent = RenderingComponent(type: .button,
                                                     position: Constants.jumpButtonPosition,
                                                     name: Constants.jumpButtonImage,
                                                     size: Constants.jumpButtonSize)
        self.gameEngine = gameEngine
        self.associatedEntity = associatedEntity
    }

    func handleTouchBegan(touchLocation: CGPoint) {
        guard renderingComponent.contains(touchLocation) else {
            return
        }

        notifyJump(entity: associatedEntity)
    }

    func activate(renderingSystem: RenderingSystem) -> Entity {
        let entity = Entity(type: .button)
        renderingSystem.addComponent(entity: entity,
                                     component: renderingComponent)

        return entity
    }

    private func notifyJump(entity: Entity) {
        let newInput = Input(inputType: .jump(entity: entity))
        gameEngine.inputManager.parseInput(input: newInput)
    }
}
