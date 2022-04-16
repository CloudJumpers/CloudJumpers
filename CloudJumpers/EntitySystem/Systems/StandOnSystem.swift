//
//  LocationSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/11/22.
//

import Foundation
import CoreGraphics

class StandOnSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func changeStandOnEntity(for id: EntityID, to standOnEntityID: EntityID?, at timestamp: TimeInterval) {
        guard let standOnComponent = manager?.component(ofType: StandOnComponent.self, of: id) else {
            return
        }
        standOnComponent.standOnEntityID = standOnEntityID
        standOnComponent.timestamp = timestamp

    }
}
