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
    var size: CGSize

    var alpha: CGFloat = 1.0

    init(text: String, size: CGSize) {
        self.text = text
        self.size = size
        super.init()
    }
}
