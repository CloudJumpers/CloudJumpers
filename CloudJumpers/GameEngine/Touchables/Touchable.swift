//
//  Touchable.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import CoreGraphics

protocol Touchable {
    func handleTouchBegan(touchLocation: CGPoint) -> Event?
    func handleTouchMoved(touchLocation: CGPoint) -> Event?
    func handleTouchEnded(touchLocation: CGPoint) -> Event?
    func update() -> Event?
}

extension Touchable {
    func handleTouchBegan(touchLocation: CGPoint) -> Event? { nil }
    func handleTouchMoved(touchLocation: CGPoint) -> Event? { nil }
    func handleTouchEnded(touchLocation: CGPoint) -> Event? { nil }
    func update() -> Event? { nil }
}
