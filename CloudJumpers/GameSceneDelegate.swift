//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/3/22.
//

import SpriteKit

protocol GameSceneDelegate: AnyObject {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval)

    func scene(_ scene: GameScene, didBeginTouchAt location: CGPoint)
    func scene(_ scene: GameScene, didMoveTouchAt location: CGPoint)
    func scene(_ scene: GameScene, didEndTouchAt location: CGPoint)

    func scene(_ scene: GameScene, didBeginContactBetween nodeA: SKNode, and nodeB: SKNode)
    func scene(_ scene: GameScene, didEndContactBetween nodeA: SKNode, and nodeB: SKNode)
}
