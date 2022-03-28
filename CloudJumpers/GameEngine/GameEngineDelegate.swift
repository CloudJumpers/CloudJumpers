//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/3/22.
//

import SpriteKit

protocol GameEngineDelegate: AnyObject {
    func engine(_ engine: AbstractGameEngine, addEntityWith node: SKNode)
    func engine(_ engine: AbstractGameEngine, addPlayerWith node: SKNode)
    func engine(_ engine: AbstractGameEngine, addControlWith node: SKNode)
}
