//
//  Touchable.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import CoreGraphics

protocol Touchable {
    func handleTouchBegan(touchLocation: CGPoint)

    func handleTouchMoved(touchLocation: CGPoint)

    func handleTouchEnded(touchLocation: CGPoint)

    func update()
}

// all functions are empty by default
extension Touchable {
    func handleTouchBegan(touchLocation: CGPoint) {

    }

    func handleTouchMoved(touchLocation: CGPoint) {

    }

    func handleTouchEnded(touchLocation: CGPoint) {

    }

    func update() {

    }
}
