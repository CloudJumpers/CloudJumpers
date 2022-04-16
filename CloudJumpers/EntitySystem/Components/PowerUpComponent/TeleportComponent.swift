//
//  TeleportComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class TeleportComponent: Component, PowerUpEffectComponent {
    let position: CGPoint
    let activatorId: EntityID
    var isActivated = false

    init(position: CGPoint, activatorId: EntityID) {
        self.position = position
        self.activatorId = activatorId
    }
}
