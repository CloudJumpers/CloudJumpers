//
//  DisasterHitEventsFactory.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//
import Foundation
import CoreGraphics

class DisasterHitEventsFactory {
    private static let availableDisasterHitEvents: [DisasterHitEventCreator.Type] = [
        MeteorHitEventCreator.self
    ]

    static func createDisasterHitEvent(type: DisasterComponent.Kind,
                                       from disasterID: EntityID,
                                       on entityID: EntityID) -> Event {

        for availableDisaster in availableDisasterHitEvents {
            let disaster = availableDisaster.init()
            if disaster.doesMatch(type: type) {
                return disaster.create(from: disasterID, on: entityID)
            }
        }

        fatalError("Unable to find a matching Disaster Event for type =\(type.rawValue)")
    }
}
