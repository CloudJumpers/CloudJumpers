//
//  LocationSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/11/22.
//

import Foundation
import CoreGraphics

class LocationSystem: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        return
    }

    func addLocation(for id: EntityID, to standOnEntityID: EntityID) {
        guard let locationComponent = manager?.component(ofType: LocationComponent.self, of: id) else {
            return
        }
        locationComponent.standOnEntityID = standOnEntityID
    }
    
    func removeLocation(for id: EntityID, to standOnEntityID: EntityID) {
        guard let locationComponent = manager?.component(ofType: LocationComponent.self, of: id),
              locationComponent.standOnEntityID == standOnEntityID
        else {
            return
        }
        locationComponent.standOnEntityID = nil
    }
    
    
}
