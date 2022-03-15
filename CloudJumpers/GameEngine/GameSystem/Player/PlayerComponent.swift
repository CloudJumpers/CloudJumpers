//
//  PlayerComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation
import CoreGraphics

class PlayerComponent: Component {
    var location: Location

    init(location: Location = .start) {
        self.location = location
    }

    enum Location {
        case start, air, cloud(entity: Entity), platform(entity: Entity)
    }
}
