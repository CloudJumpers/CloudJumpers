//
//  Timer.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Timer: Entity {
    let id: EntityID

    private var position: CGPoint
    private var initial: Double

    init(with id: EntityID?, at position: CGPoint, initial: Double) {
        self.id = id ?? UUID().uuidString
        self.position = position
        self.initial = initial
    }

    convenience init(at position: CGPoint, initial: Double) {
        self.init(with: nil, at: position, initial: initial)
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let timedComponent = createTimedComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(timedComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let labelNode = SKLabelNode()
        labelNode.position = position
        labelNode.fontSize = Constants.timerSize.width
        labelNode.text = "\(initial)"
        labelNode.fontColor = .black
        labelNode.zPosition = SpriteZPosition.timer.rawValue

        return SpriteComponent(node: labelNode)
    }

    private func createTimedComponent() -> TimedComponent {
        TimedComponent(time: initial)
    }
}
