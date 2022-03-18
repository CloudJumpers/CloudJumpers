//
//  TimerSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/3/22.
//

import Foundation
import SpriteKit

class TimerSystem: System {
    weak var entitiesManager: EntitiesManager?
    private var entityComponentMapping: [Entity: TimerComponent] = [:]

    init(entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }

    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let node = entitiesManager?.getNode(of: entity) as? SKLabelNode,
                  let component = entityComponentMapping[entity] else {
                return
            }

            component.time += deltaTime
            node.text = String(format: "%.1f", component.time)

        }
    }

    func getTime() -> Double {
        guard let time = entityComponentMapping.first?.value.time else {
            return 0
        }
        return time
    }

    func addComponent(entity: Entity, component: Component) {
        // only add timer once
        guard entityComponentMapping.isEmpty else {
            return
        }

        if let timerEntity = entity as? TimerEntity,
           let timerComponent = component as? TimerComponent {
            entityComponentMapping[timerEntity] = timerComponent
        }
    }

}
