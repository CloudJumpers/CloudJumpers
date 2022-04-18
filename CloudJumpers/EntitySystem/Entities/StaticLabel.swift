//
//  StaticLabel.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import UIKit

class StaticLabel: Entity {
    let id: EntityID

    private var position: CGPoint
    private var typeface: Fonts
    private var size: CGFloat
    private var text: String
    private var color: UIColor

    init(
        at position: CGPoint,
        typeface: Fonts,
        size: CGFloat,
        text: String,
        color: UIColor = .black,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.position = position
        self.typeface = typeface
        self.size = size
        self.color = color
        self.text = text
    }

    func setUpAndAdd(to manager: EntityManager) {
        manager.addComponent(createLabelComponent(), to: self)
        manager.addComponent(PositionComponent(at: position), to: self)
        manager.addComponent(CameraStaticTag(), to: self)
    }

    private func createLabelComponent() -> LabelComponent {
        let labelComponent = LabelComponent(text: text, size: size)
        labelComponent.typeface = typeface
        labelComponent.color = color
        return labelComponent
    }
}
