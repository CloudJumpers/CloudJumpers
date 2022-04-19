//
//  MeteorEventCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//
import Foundation

class MeteorHitEventCreator: DisasterHitEventCreator {
    required init() {}

    func create(from disasterId: EntityID, on entityID: EntityID) -> Event {
        DisasterPlayerCollideEvent(from: disasterId, on: entityID)
    }

    func doesMatch(type: DisasterComponent.Kind) -> Bool {
        type == .meteor
    }
}
