//
//  BlackoutComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class BlackoutComponent: Component {
    let activatorId: EntityID
    var isActivated = false

    init(position: CGPoint, activatorId: EntityID) {
        self.activatorId = activatorId
    }
}
