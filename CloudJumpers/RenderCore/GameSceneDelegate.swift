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

    func scene(_ scene: GameScene, didBeginTouchesAt locations: [CGPoint])
    func scene(_ scene: GameScene, didMoveTouchesAt locations: [CGPoint])
    func scene(_ scene: GameScene, didEndTouchesAt locations: [CGPoint])
    func scene(_ scene: GameScene, didCompletedTouchAt location: CGPoint)
}

extension GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) { }

    func scene(_ scene: GameScene, didBeginTouchesAt locations: [CGPoint]) { }
    func scene(_ scene: GameScene, didMoveTouchesAt locations: [CGPoint]) { }
    func scene(_ scene: GameScene, didEndTouchesAt locations: [CGPoint]) { }
    func scene(_ scene: GameScene, didCompletedTouchAt location: CGPoint) { }
}
