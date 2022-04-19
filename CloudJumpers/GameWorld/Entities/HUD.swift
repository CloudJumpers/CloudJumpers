//
//  HUD.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 18/4/22.
//

import CoreGraphics

class HUD: Entity {
    let id: EntityID

    private var position: CGPoint

    init(at position: CGPoint, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        manager.addComponent(createSpriteComponent(), to: self)
        manager.addComponent(PositionComponent(at: position), to: self)
        manager.addComponent(CameraStaticTag(), to: self)
        manager.addComponent(HUDComponent(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: HUDs.hud0.frame,
            size: Dimensions.hud,
            zPosition: .hud)

        return spriteComponent
    }
}
