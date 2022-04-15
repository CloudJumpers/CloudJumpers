//
//  LabelComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation

import SpriteKit

class LabelComponent: Component {
    let displayValue: String
    let size: CGSize
    let position: CGPoint

    var alpha: CGFloat = 1.0

    init(displayValue: String, size: CGSize, position: CGPoint) {
        self.displayValue = displayValue
        self.size = size
        self.position = position
        super.init()
    }
}
