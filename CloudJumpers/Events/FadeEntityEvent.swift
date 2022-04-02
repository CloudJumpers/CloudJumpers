//
//  FadeEntityEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation

struct FadeEntityEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    let previousUpdateTime: TimeInterval
    let fadingEndTime: TimeInterval

    init(on entity: Entity, until endTime: TimeInterval, previousUpdateTime: TimeInterval = 0) {
        timestamp = EventManager.timestamp
        self.entityID = entity.id
        self.previousUpdateTime = previousUpdateTime
        self.fadingEndTime = endTime
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        guard let entity = entityManager.entity(with: entityID),
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: entity) else {
                  return true
              }

        return previousUpdateTime < timedComponent.time
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: entity),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              timedComponent.time < fadingEndTime
        else {
              return nil
        }

        let currentTime = timedComponent.time
        print(currentTime)

        spriteComponent.node.alpha = (fadingEndTime - currentTime) / fadingEndTime
        return [FadeEntityEvent(on: entity, until: fadingEndTime, previousUpdateTime: currentTime)]
    }
}
