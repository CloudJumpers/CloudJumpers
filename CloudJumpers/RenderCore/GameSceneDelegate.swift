//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/3/22.
//

import Foundation
import CoreGraphics

protocol GameSceneDelegate: AnyObject {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval)

    func scene(_ scene: GameScene, didBeginTouchAt location: CGPoint)
    func scene(_ scene: GameScene, didMoveTouchAt location: CGPoint)
    func scene(_ scene: GameScene, didEndTouchAt location: CGPoint)

    func scene(_ scene: GameScene, didBeginContactBetween nodeA: Node, and nodeB: Node)
    func scene(_ scene: GameScene, didEndContactBetween nodeA: Node, and nodeB: Node)

    func scene(_ scene: GameScene, didUpdateBecome positions: [CGPoint])
}

extension GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) { }

    func scene(_ scene: GameScene, didBeginTouchAt location: CGPoint) { }
    func scene(_ scene: GameScene, didMoveTouchAt location: CGPoint) { }
    func scene(_ scene: GameScene, didEndTouchAt location: CGPoint) { }

    func scene(_ scene: GameScene, didBeginContactBetween nodeA: Node, and nodeB: Node) { }
    func scene(_ scene: GameScene, didEndContactBetween nodeA: Node, and nodeB: Node) { }

    func scene(_ scene: GameScene, didUpdateBecome positions: [CGPoint]) { }
}
