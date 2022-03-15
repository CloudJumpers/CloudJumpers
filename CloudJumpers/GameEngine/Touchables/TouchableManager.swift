//
//  TouchableManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import CoreGraphics

class TouchableManager {
    private var touchables: [Touchable] = []

    func addTouchable(touchable: Touchable) {
        touchables.append(touchable)
    }

    func handleTouchBeganEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchBegan(touchLocation: location)
        }
    }

    func handleTouchMovedEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchMoved(touchLocation: location)
        }
    }

    func handleTouchEndedEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchEnded(touchLocation: location)
        }
    }

    func updateTouchables() {
        for touchable in touchables {
            touchable.update()
        }
    }

}
