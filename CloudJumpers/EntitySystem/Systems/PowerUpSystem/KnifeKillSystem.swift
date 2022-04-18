//
//  KnifeKillSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

class KnifeKillSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let knifeKillComponents = manager?.components(ofType: KnifeKillComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity
        else { return }

        for component in knifeKillComponents where !component.isActivated {
            component.isActivated = true

            guard component.activatorId == playerEntity.id else {
                continue
            }

            respawnClosestPlayer(to: component)
        }
    }

    private func respawnClosestPlayer(to knifeKillComponent: KnifeKillComponent) {
        guard let manager = manager else {
            return
        }

        var guestInfo: [(CGPoint, EntityID)] = []
        var guessIdToRespawn: EntityID?
        var minDistance = CGFloat.greatestFiniteMagnitude
        for entity in manager.entities {
            guard let guest = entity as? Guest,
                  let positionComponent = manager.component(ofType: PositionComponent.self, of: guest.id) else {
                continue
            }

            guestInfo.append((positionComponent.position, guest.id))
        }

        let killLocation = knifeKillComponent.position

        for (position, id) in guestInfo {
            if killLocation.distance(to: position) < minDistance {
                minDistance = killLocation.distance(to: position)
                guessIdToRespawn = id
            }
        }

        guard let guessIdToRespawn = guessIdToRespawn,
              minDistance <= knifeKillComponent.radiusRange else {
            return
        }

        dispatcher?.dispatch(ExternalKillEntityEvent(killedEntityID: guessIdToRespawn))
    }
}
