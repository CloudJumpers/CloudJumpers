//
//  ShadowDisasterEffector.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 18/4/22.
//

import Foundation

struct ShadowDisasterEffector: Effector {
    let entityID: EntityID

    func apply(to event: Event) -> Event {
        guard let event = event as? DisasterSpawnEvent else {
            return event
        }

        return event.then(do: OpacityChangeEvent(on: event.entityID, opacity: GameConstants.shadowOpacity))
    }

    func shouldDetach(in target: EventModifiable) -> Bool {
        false
    }
}
