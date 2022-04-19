//
//  SpriteNode.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 6/4/22.
//

import SpriteKit

public typealias SpriteNodeCore = SKSpriteNode

public class SpriteNode: Node {
    private static let animationKeyPrefix = "CJAnimate:"
    private var captionNode: LabelNode?

    public var activeAnimationKey: String = ""

    public init(texture: TextureFrame, size: CGSize) {
        super.init()
        coreNode = SpriteNodeCore(texture: Texture.texture(of: texture), size: size)
    }

    public var anchorPoint: CGPoint {
        get { coreSpriteNode.anchorPoint }
        set { coreSpriteNode.anchorPoint = newValue }
    }

    override public var xScale: CGFloat {
        get { super.xScale }

        set {
            super.xScale = newValue
            captionNode?.xScale = newValue
        }
    }

    override public var yScale: CGFloat {
        get { super.yScale }

        set {
            super.yScale = newValue
            captionNode?.yScale = newValue
        }
    }

    public func caption(
        _ caption: String,
        at position: CGPoint,
        size: CGFloat,
        typeface: String,
        truncateBy maxLength: Int,
        color: UIColor = .black) {
        let truncatedCaption = caption.truncate(by: maxLength)
        let captionNode = LabelNode(text: truncatedCaption)
        captionNode.fontName = typeface
        captionNode.fontSize = size
        captionNode.position = position
        captionNode.fontColor = color
        addChild(captionNode)
        self.captionNode = captionNode
    }

    public func animateLoop(with textures: [TextureFrame], interval: TimeInterval, key: String = "") {
        coreNode.removeAction(forKey: animationKey(with: activeAnimationKey))

        coreNode.run(.repeatForever(.animate(
            with: Texture.textures(of: textures),
            timePerFrame: interval,
            resize: false,
            restore: true)),
        withKey: animationKey(with: key))

        self.activeAnimationKey = key
    }

    public func setTexture(to texture: TextureFrame) {
        coreSpriteNode.texture = Texture.texture(of: texture)
    }

    private func animationKey(with key: String) -> String {
        Self.animationKeyPrefix + key
    }

    private var coreSpriteNode: SpriteNodeCore {
        guard let coreSpriteNode = coreNode as? SpriteNodeCore else {
            fatalError("A NodeCore of a SpriteNode is not compatible with SpriteNodeCore")
        }

        return coreSpriteNode
    }

    @available(*, unavailable)
    override init() {
        fatalError("SpriteNode() is unavailable")
    }
}
