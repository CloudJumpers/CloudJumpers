//
//  PlayerEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import Foundation
import CoreGraphics

class PlayerEntity: Entity, Renderable {
    var renderingComponent: RenderingComponent

    init(position: CGPoint) {
        self.renderingComponent = RenderingComponent(type: .sprite,
                                                     position: position,
                                                     name: Constants.playerImage,
                                                     size: Constants.playerSize)
        super.init(type: .player)
    }

    func activate(renderingSystem: RenderingSystem) {
        renderingSystem.addComponent(entity: self, component: renderingComponent)
    }

}
