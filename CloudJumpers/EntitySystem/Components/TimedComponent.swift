//
//  TimedComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import Foundation

class TimedComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    var time: Double

    init(time: Double) {
        id = EntityManager.newComponentID
        self.time = time
    }
}
