//
//  SpriteNode.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 6/4/22.
//

import SpriteKit

typealias SpriteNodeCore = SKSpriteNode

class SpriteNode: Node {
    private static let animationKeyPrefix = "CJAnimate:"

    private var captionNode: LabelNode?
    var activeAnimationKey: String = ""

    init(texture: TextureFrame, size: CGSize) {
        super.init()
        coreNode = SpriteNodeCore(texture: Texture.texture(of: texture), size: size)
    }

    var anchorPoint: CGPoint {
        get { coreSpriteNode.anchorPoint }
        set { coreSpriteNode.anchorPoint = newValue }
    }

    override var xScale: CGFloat {
        get { super.xScale }

        set {
            super.xScale = newValue
            captionNode?.xScale = newValue
        }
    }

    override var yScale: CGFloat {
        get { super.yScale }

        set {
            super.yScale = newValue
            captionNode?.yScale = newValue
        }
    }

    func caption(with caption: String, color: UIColor = .black) {
        let truncatedCaption = caption.truncate(by: Constants.captionMaxLength)
        let captionNode = LabelNode(text: truncatedCaption)
        captionNode.fontName = Constants.captionFontName
        captionNode.fontSize = Constants.captionFontSize
        captionNode.position = Constants.captionRelativePosition
        captionNode.fontColor = color
        addChild(captionNode)
        self.captionNode = captionNode
    }

    func animateLoop(with textures: [TextureFrame], interval: TimeInterval, key: String = "") {
        coreNode.removeAction(forKey: animationKey(with: activeAnimationKey))

        coreNode.run(.repeatForever(.animate(
            with: Texture.textures(of: textures),
            timePerFrame: interval,
            resize: false,
            restore: true)),
        withKey: animationKey(with: key))

        self.activeAnimationKey = key
    }

    func setTexture(to texture: TextureFrame) {
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
