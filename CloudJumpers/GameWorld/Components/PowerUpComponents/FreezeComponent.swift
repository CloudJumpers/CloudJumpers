//
//  FreezeComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class FreezeComponent: Component {
    let position: CGPoint
    let activatorId: EntityID
    let radiusRange: CGFloat
    var isActivated = false

    init(
        position: CGPoint,
        activatorId: EntityID,
        radiusRange: CGFloat = Constants.PowerUps.powerUpTargetRange
    ) {
        self.position = position
        self.activatorId = activatorId
        self.radiusRange = radiusRange
    }
}
