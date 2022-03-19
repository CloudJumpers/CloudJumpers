//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/3/22.
//

import SpriteKit

protocol GameEngineDelegate: AnyObject {
    func engine(_ engine: GameEngine, didEndGameWith state: GameState)
    func engine(_ engine: GameEngine, addEntityWith node: SKNode)
    func engine(_ engine: GameEngine, addPlayerWith node: SKNode)
    func engine(_ engine: GameEngine, addControlWith node: SKNode)
}
