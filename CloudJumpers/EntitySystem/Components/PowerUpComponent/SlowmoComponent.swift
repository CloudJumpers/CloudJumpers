//
//  SlowmoComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class SlowmoComponent: Component, PowerUpEffectComponent {
    let position: CGPoint
    let activatorId: EntityID
    let radiusRange: CGFloat
    var isActivated = false

    init(position: CGPoint, activatorId: EntityID, radiusRange: CGFloat = Constants.powerUpTargetRange) {
        self.position = position
        self.activatorId = activatorId
        self.radiusRange = radiusRange
    }
}
