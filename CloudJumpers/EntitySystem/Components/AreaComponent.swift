//
//  AreaComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/4/22.
//

import CoreGraphics

class AreaComponent: Component {
    let size: CGSize

    var scrollable = false
    var isBlank = false

    init(size: CGSize) {
        self.size = size
        super.init()
    }
}
