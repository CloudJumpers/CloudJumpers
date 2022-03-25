//
//  Freeze.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import Foundation
import CoreGraphics

class Freeze: PowerUp {
    init(at position: CGPoint, with id: EntityID = newID) {
        super.init(at: position, with: id, type: .freeze, name: Images.freezeButton.name)
    }
}
