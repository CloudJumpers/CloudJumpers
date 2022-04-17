//
//  Node.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import SpriteKit

typealias NodeCore = SKNode

class Node {
    var coreNode: NodeCore
    var name: String?

    init() {
        coreNode = NodeCore()
    }

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    var position: CGPoint {
        get { coreNode.position }
        set { coreNode.position = newValue }
    }

    var zPosition: CGFloat {
        get { coreNode.zPosition }
        set { coreNode.zPosition = newValue }
    }

    var alpha: CGFloat {
        get { coreNode.alpha }
        set { coreNode.alpha = newValue }
    }

    var zRotation: CGFloat {
        get { coreNode.zRotation }
        set { coreNode.zRotation = newValue }
    }

    var xScale: CGFloat {
        get { coreNode.xScale }
        set { coreNode.xScale = newValue }
    }

    var yScale: CGFloat {
        get { coreNode.yScale }
        set { coreNode.yScale = newValue }
    }

    var physicsBody: PhysicsBody? {
        didSet {
            coreNode.physicsBody = physicsBody?.coreBody
        }
    }

    func addChild(_ node: Node) {
        coreNode.addChild(node.coreNode)
    }

    func move(to position: CGPoint, within duration: TimeInterval) {
        coreNode.run(.move(to: position, duration: duration))
    }

    func move(by displacement: CGVector, within duration: TimeInterval) {
        coreNode.run(.move(by: displacement, duration: duration))
    }
}

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.coreNode == rhs.coreNode
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coreNode)
    }
}
