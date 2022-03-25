//
//  TimedComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import Foundation

class TimedComponent: Component {
    let id: ID
    unowned var entity: Entity?

    var time: Double

    init(time: Double) {
        id = UUID()
        self.time = time
    }
}
