//
//  Timer.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Timer: Entity {
    let id: ID

    private var position: CGPoint
    private var initial: Double

    init(at position: CGPoint, initial: Double) {
        id = UUID()
        self.position = position
        self.initial = initial
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