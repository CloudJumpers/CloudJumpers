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

    private var previousUpdateTime: TimeInterval
    private var fadingEndTime: TimeInterval
    private var fadeType: FadeType

    init(on entity: Entity, until endTime: TimeInterval, previousUpdateTime: TimeInterval = 0, fadeType: FadeType = .fadeOut) {
        timestamp = EventManager.timestamp
        self.entityID = entity.id
        self.previousUpdateTime = previousUpdateTime
        self.fadingEndTime = endTime
        self.fadeType = fadeType
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
        switch fadeType {
        case .fadeIn:
            spriteComponent.node.alpha = currentTime / fadingEndTime
        case .fadeOut:
            spriteComponent.node.alpha = (fadingEndTime - currentTime) / fadingEndTime
        }

        return [FadeEntityEvent(on: entity, until: fadingEndTime, previousUpdateTime: currentTime, fadeType: fadeType)]
    }
}

enum FadeType {
    case fadeIn
    case fadeOut
}
