//
//  KnifeKillComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

class KnifeKillComponent: Component {
    let activatorId: EntityID
    let position: CGPoint
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
