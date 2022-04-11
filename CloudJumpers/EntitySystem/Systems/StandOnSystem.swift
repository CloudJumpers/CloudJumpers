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

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        }

    func addLocation(for id: EntityID, to standOnEntityID: EntityID, at timestamp: TimeInterval) {
        guard let standOnComponent = manager?.component(ofType: StandOnComponent.self, of: id) else {
            return
        }
        standOnComponent.standOnEntityID = standOnEntityID
        standOnComponent.timestamp = timestamp

    }

    func removeLocation(for id: EntityID, to standOnEntityID: EntityID) {
        guard let standOnComponent = manager?.component(ofType: StandOnComponent.self, of: id),
              standOnComponent.standOnEntityID == standOnEntityID
        else {
            return
        }
        standOnComponent.standOnEntityID = nil
    }

}
