//
//  TouchableManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import CoreGraphics

class TouchableManager {
    private var touchables: [Touchable] = []
    weak var eventDelegate: EventDelegate?

    func addTouchable(touchable: Touchable) {
        touchables.append(touchable)
    }

    func handleTouchBeganEvent(location: CGPoint) {
        for touchable in touchables {
            if let input = touchable.handleTouchBegan(touchLocation: location) {
                eventDelegate?.event(add: Event(type: .input(info: input)))
            }
        }
    }

    func handleTouchMovedEvent(location: CGPoint) {
        for touchable in touchables {
            if let input = touchable.handleTouchMoved(touchLocation: location) {
                eventDelegate?.event(add: Event(type: .input(info: input)))
            }
        }
    }

    func handleTouchEndedEvent(location: CGPoint) {
        for touchable in touchables {
            if let input = touchable.handleTouchEnded(touchLocation: location) {
                eventDelegate?.event(add: Event(type: .input(info: input)))
            }
        }
    }

    func updateTouchables() {
        for touchable in touchables {

            if let input = touchable.update() {
                eventDelegate?.event(add: Event(type: .input(info: input)))
            }
        }
    }

}
