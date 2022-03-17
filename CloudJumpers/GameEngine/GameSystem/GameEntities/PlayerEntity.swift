//
//  PlayerEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import CoreGraphics

class PlayerEntity: Entity, Renderable {
    var renderingComponent: RenderingComponent

    init(position: CGPoint) {
        self.renderingComponent = RenderingComponent(type: .physicalSprite(shape:
                .rectangle(size: Constants.playerSize)),
                                                     position: position,
                                                     name: Images.player.name,
                                                     size: Constants.playerSize)
        super.init(type: .player)
    }

    func activate(renderingSystem: RenderingSystem) {
        renderingSystem.addComponent(entity: self, component: renderingComponent)
    }

}
