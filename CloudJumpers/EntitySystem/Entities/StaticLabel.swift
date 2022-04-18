//
//  StaticLabel.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation
import SpriteKit

class StaticLabel: Entity {
    let id: EntityID

    private var position: CGPoint
    private var fontSize: CGFloat
    private var text: String

    init(at position: CGPoint, fontSize: CGFloat, text: String, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
        self.fontSize = fontSize
        self.text = text
    }

    func setUpAndAdd(to manager: EntityManager) {
        manager.addComponent(PositionComponent(at: position), to: self)
        manager.addComponent(LabelComponent(text: text, fontSize: fontSize), to: self)
        manager.addComponent(CameraStaticTag(), to: self)
    }
}
