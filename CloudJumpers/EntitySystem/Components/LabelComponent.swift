//
//  LabelComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation

import SpriteKit

class LabelComponent: Component {
    var text: String

    var alpha: CGFloat = 1.0
    var zPosition = SpriteZPosition.label.rawValue
    var fontSize: CGFloat

    init(text: String, fontSize: CGFloat) {
        self.text = text
        self.fontSize = fontSize
        super.init()
    }
}
