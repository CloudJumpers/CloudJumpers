//
//  TimedRemovalComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation

// MARK: Adopt from previous remove event
class TimedRemovalComponent: Component {
    let timeToRemove: TimeInterval

    init(timeToRemove: TimeInterval) {
        self.timeToRemove = timeToRemove
        super.init()
    }
}
