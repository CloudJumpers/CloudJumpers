//
//  LabelComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import UIKit

class LabelComponent: Component {
    var text: String

    var typeface: Fonts?
    var alpha: CGFloat = 1.0
    var zPosition = ZPositions.label.rawValue
    var size: CGFloat
    var color = UIColor.black

    init(text: String, size: CGFloat) {
        self.text = text
        self.size = size
        super.init()
    }
}
