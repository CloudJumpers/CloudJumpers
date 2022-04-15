//
//  TeleportSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class TeleportSystem: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let teleportComponents = manager?.components(ofType: TeleportComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in teleportComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = playerPositionComponent.position

            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, teleportComponent: component) {
                let nextPosition = getNextCloudPosition(currentLocation: playerLocation) + Constants.teleportCloudGapY

                playerPositionComponent.position = nextPosition

                // TODO: Add remote event to reposition this player
            }
        }
    }

    private func getNextCloudPosition(currentLocation: CGPoint) -> CGPoint {
        guard let manager = manager else {
            return CGPoint.zero
        }

        var cloudPositions: [CGPoint] = []
        for entity in manager.entities where entity is Cloud || entity is Platform {
            if let positionComponent = manager.component(ofType: PositionComponent.self, of: entity) {
                cloudPositions.append(positionComponent.position)
            }
        }

        cloudPositions = cloudPositions.sorted(by: { $0.y < $1.y })

        for cloudPosition in cloudPositions where cloudPosition.y > currentLocation.y {
            return cloudPosition
        }
        return cloudPositions.last ?? CGPoint.zero
    }

    private func isAffectingLocation(location: CGPoint, teleportComponent: TeleportComponent) -> Bool {
        true
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId == targetEntityId
    }
}
