//
//  LocationComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/16/22.
//

import Foundation

class LocationComponent: Component {
    var location: Location

    init(location: Location = .air) {
        self.location = location
    }

    enum Location {
        case air
        case on(entity: Entity)
    }
}
