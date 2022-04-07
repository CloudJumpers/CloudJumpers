//
//  RepositionEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation
import CoreGraphics

struct RepositionEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let nextPosition: CGPoint
    private let kind: Textures.Kind

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, to nextPosition: CGPoint, as kind: Textures.Kind) {
        entityID = id
        self.timestamp = timestamp
        self.nextPosition = nextPosition
        self.kind = kind
    }

    init(onEntityWith id: EntityID, to nextPosition: CGPoint, as kind: Textures.Kind) {
        entityID = id
        self.timestamp = EventManager.timestamp
        self.nextPosition = nextPosition
        self.kind = kind
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity)
        else { return }

        let displacement = CGVector(
            dx: nextPosition.x - spriteComponent.node.position.x,
            dy: nextPosition.y - spriteComponent.node.position.y

        )

        if abs(displacement.dx) >= 0.1 {
            spriteComponent.node.xScale = (displacement.dx / abs(displacement.dx) )
            spriteComponent.node.children.forEach({ $0.xScale = (displacement.dx / abs(displacement.dx) ) })
        }
        spriteComponent.node.run(.move(by: displacement, duration: 0.05))
        animationComponent.kind = kind
    }
}
