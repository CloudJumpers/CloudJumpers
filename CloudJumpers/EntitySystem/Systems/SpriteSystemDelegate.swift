//
//  SpriteSystemDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/3/22.
//

import SpriteKit

protocol SpriteSystemDelegate: AnyObject {
    func spriteSystem(_ system: SpriteSystem, addNode node: SKNode, static: Bool)
    func spriteSystem(_ system: SpriteSystem, removeNode node: SKNode)
    func spriteSystem(_ system: SpriteSystem, bindCameraTo node: SKNode)
}

extension SpriteSystemDelegate {
    func spriteSystem(_ system: SpriteSystem, addNode node: SKNode, static: Bool) { }
    func spriteSystem(_ system: SpriteSystem, removeNode node: SKNode) { }
    func spriteSystem(_ system: SpriteSystem, bindCameraTo node: SKNode) { }
}
