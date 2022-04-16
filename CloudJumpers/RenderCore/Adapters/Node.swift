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
    private static let animationKeyPrefix = "CJAnimate:"
    private var captionNodeCore: SKLabelNode?

    let nodeCore: NodeCore
    var name: String?
    var activeAnimationKey: String = ""

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

    var xScale: CGFloat {
        get { nodeCore.xScale }
        set { nodeCore.xScale = newValue }
    }

    var yScale: CGFloat {
        get { nodeCore.yScale }
        set { nodeCore.yScale = newValue }
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

    func animateLoop(with textures: [TextureFrame], interval: TimeInterval, key: String = "") {
        nodeCore.removeAction(forKey: animationKey(with: activeAnimationKey))

        nodeCore.run(.repeatForever(.animate(
            with: Texture.textures(of: textures),
            timePerFrame: interval,
            resize: false,
            restore: true)),
        withKey: animationKey(with: key))

        self.activeAnimationKey = key
    }

    private func animationKey(with key: String) -> String {
        Self.animationKeyPrefix + key
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
