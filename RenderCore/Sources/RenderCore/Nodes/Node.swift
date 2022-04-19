//
//  Node.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import SpriteKit

public typealias NodeCore = SKNode

public class Node {
    public var coreNode: NodeCore
    public var name: String?

    public init() {
        coreNode = NodeCore()
    }

    public convenience init(name: String) {
        self.init()
        self.name = name
    }

    public var position: CGPoint {
        get { coreNode.position }
        set { coreNode.position = newValue }
    }

    public var zPosition: CGFloat {
        get { coreNode.zPosition }
        set { coreNode.zPosition = newValue }
    }

    public var alpha: CGFloat {
        get { coreNode.alpha }
        set { coreNode.alpha = newValue }
    }

    public var zRotation: CGFloat {
        get { coreNode.zRotation }
        set { coreNode.zRotation = newValue }
    }

    public var xScale: CGFloat {
        get { coreNode.xScale }
        set { coreNode.xScale = newValue }
    }

    public var yScale: CGFloat {
        get { coreNode.yScale }
        set { coreNode.yScale = newValue }
    }

    public var physicsBody: PhysicsBody? {
        didSet {
            coreNode.physicsBody = physicsBody?.coreBody
        }
    }

    public func addChild(_ node: Node) {
        coreNode.addChild(node.coreNode)
    }

    public func move(to position: CGPoint, within duration: TimeInterval) {
        coreNode.run(.move(to: position, duration: duration))
    }

    public func move(by displacement: CGVector, within duration: TimeInterval) {
        coreNode.run(.move(by: displacement, duration: duration))
    }
}

extension Node: Hashable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.coreNode == rhs.coreNode
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(coreNode)
    }
}
