//
//  RepositionEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation
import CoreGraphics

struct RepositionEvent: SharedEvent {
    var isSharing: Bool
    var isExecutedLocally: Bool
    let timestamp: TimeInterval
    let entityID: EntityID

    private let nextPosition: CGPoint
    private let kind: Textures.Kind

    init(onEntityWith id: EntityID,
         at timestamp: TimeInterval,
         to nextPosition: CGPoint,
         as kind: Textures.Kind,
         isSharing: Bool,
         isExecutedLocally: Bool) {
        entityID = id
        self.timestamp = timestamp
        self.nextPosition = nextPosition
        self.kind = kind
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    init(onEntityWith id: EntityID,
         to nextPosition: CGPoint,
         as kind: Textures.Kind,
         isSharing: Bool,
         isExecutedLocally: Bool) {
        entityID = id
        timestamp = EventManager.timestamp
        self.nextPosition = nextPosition
        self.kind = kind
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity)
        else { return nil }

        let displacement = CGVector(
            dx: nextPosition.x - spriteComponent.node.position.x,
            dy: nextPosition.y - spriteComponent.node.position.y
        )
        if displacement.dx != 0 {
            spriteComponent.node.xScale = abs(spriteComponent.node.xScale) * (displacement.dx / abs(displacement.dx) )
        }
        spriteComponent.node.run(.move(by: displacement, duration: 0.1))
        animationComponent.kind = kind

        return nil
    }

    func getSharedCommand() -> GameEventCommand {
        let positionalUpdate = OnlineRepositionEvent(
            positionX: nextPosition.x,
            positionY: nextPosition.y,
            texture: kind.rawValue
        )

        return RepositionEventCommand(sourceId: entityID, event: positionalUpdate)
    }
}
