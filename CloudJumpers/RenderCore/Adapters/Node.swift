//
//  Node.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 6/4/22.
//

import SpriteKit

typealias NodeCore = SKNode
typealias SpriteNodeCore = SKSpriteNode

class Node {
    private var captionNodeCore: SKLabelNode?

    let nodeCore: NodeCore
    var name: String?

    var physicsBody: PhysicsBody? {
        didSet {
            nodeCore.physicsBody = physicsBody?.coreBody
        }
    }

    init(texture: TextureFrame, size: CGSize) {
        nodeCore = SpriteNodeCore(texture: Texture.texture(of: texture), size: size)
    }

    var position: CGPoint {
        get { nodeCore.position }
        set { nodeCore.position = newValue }
    }

    var zPosition: CGFloat {
        get { nodeCore.zPosition }
        set { nodeCore.zPosition = newValue }
    }

    var alpha: CGFloat {
        get { nodeCore.alpha }
        set { nodeCore.alpha = newValue }
    }

    var zRotation: CGFloat {
        get { nodeCore.zRotation }
        set { nodeCore.zRotation = newValue }
    }

    func scale(by scale: CGVector) {
        nodeCore.xScale = scale.dx
        nodeCore.yScale = scale.dy
    }

    func addChild(_ node: Node) {
        nodeCore.addChild(node.nodeCore)
    }

    func caption(with label: String, maxLen: Int, color: UIColor = .black) {
        var label = label
        if label.count > maxLen {
            let index = label.index(label.startIndex, offsetBy: maxLen)
            label = label[..<index] + "..."
        }

        let captionNodeCore = SKLabelNode(fontNamed: "AvenirNext-Bold")
        captionNodeCore.text = label
        captionNodeCore.fontSize = Constants.captionFontSize
        captionNodeCore.position = Constants.captionRelativePosition
        captionNodeCore.fontColor = color

        nodeCore.addChild(captionNodeCore)
        self.captionNodeCore = captionNodeCore
    }

    func move(to position: CGPoint, within duration: TimeInterval) {
        nodeCore.run(.move(to: position, duration: duration))
    }

    func move(by displacement: CGVector, within duration: TimeInterval) {
        nodeCore.run(.move(by: displacement, duration: duration))
    }

    func animate(with textures: [TextureFrame], interval: TimeInterval) {
        nodeCore.run(.animate(
            with: Texture.textures(of: textures),
            timePerFrame: interval,
            resize: false,
            restore: true))
    }
}

// MARK: - Hashable
extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.nodeCore == rhs.nodeCore
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeCore)
    }
}
