//
//  PowerUpLocationPressedEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/16/22.
//

import Foundation

import CoreGraphics

struct PowerUpLocationPressedEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    private let location: CGPoint

    init(location: CGPoint, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.location = location
        self.entityID = EntityID()
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let playerSystem = target.system(ofType: PlayerStateSystem.self),
              let player = playerSystem.getPlayerEntity()
        else {
            return
        }
        supplier.add(PowerUpActivateEvent(by: player.id, location: location))
        supplier.add(ExternalPowerUpActivateEvent(
            activatePowerUpPositionX: location.x,
            activatePowerUpPositionY: location.y))
    }
}
