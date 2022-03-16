//
//  Touchable.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import CoreGraphics

protocol Touchable {
    func handleTouchBegan(touchLocation: CGPoint) -> Input?

    func handleTouchMoved(touchLocation: CGPoint) -> Input?

    func handleTouchEnded(touchLocation: CGPoint) -> Input?

    func update() -> Input?
}

// all functions are empty by default
extension Touchable {
    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        nil
    }

    func handleTouchMoved(touchLocation: CGPoint) -> Input? {
        nil
    }

    func handleTouchEnded(touchLocation: CGPoint) -> Input? {
        nil
    }

    func update() -> Input? {
        nil
    }
}
