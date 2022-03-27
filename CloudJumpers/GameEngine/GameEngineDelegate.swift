//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/3/22.
//

import SpriteKit

protocol GameEngineDelegate: AnyObject {
    func engine(addEntityWith node: SKNode)
    func engine(addPlayerWith node: SKNode)
    func engine(addControlWith node: SKNode)
    func engine(removeEntityFrom node: SKNode)
}
