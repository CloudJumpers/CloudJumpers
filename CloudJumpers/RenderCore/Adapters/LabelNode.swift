//
//  LabelNode.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import SpriteKit

typealias LabelNodeCore = SKLabelNode

class LabelNode: Node {
    init(text: String) {
        super.init()
        coreNode = LabelNodeCore(text: text)
    }

    var text: String? {
        get { coreLabelNode.text }
        set { coreLabelNode.text = newValue }
    }

    var fontName: String? {
        get { coreLabelNode.fontName }
        set { coreLabelNode.fontName = newValue }
    }

    var fontSize: CGFloat {
        get { coreLabelNode.fontSize }
        set { coreLabelNode.fontSize = newValue }
    }

    var fontColor: UIColor? {
        get { coreLabelNode.fontColor }
        set { coreLabelNode.fontColor = newValue }
    }

    private var coreLabelNode: LabelNodeCore {
        guard let coreLabelNode = coreNode as? LabelNodeCore else {
            fatalError("A NodeCore of a LabelNode is not compatible with LabelNodeCore")
        }

        return coreLabelNode
    }

    @available(*, unavailable)
    override init() {
        fatalError("LabelNode() is unavailable")
    }
}
