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
    private var size: CGSize
    private var initialValue: String

    init(at position: CGPoint, size: CGSize, initialValue: String, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
        self.size = size
        self.initialValue = initialValue
    }

    func setUpAndAdd(to manager: EntityManager) {
        let labelComponent = createLabelComponent()

        manager.addComponent(labelComponent, to: self)
        manager.addComponent(CameraStaticTag(), to: self)
    }

    private func createLabelComponent() -> LabelComponent {
        LabelComponent(displayValue: initialValue, size: size, position: position)
    }
}
