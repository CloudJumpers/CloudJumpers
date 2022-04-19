//
//  DisasterHitEventCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

protocol DisasterHitEventCreator {
    init()

    func create(from disasterId: EntityID, on entityID: EntityID) -> Event

    func doesMatch(type: DisasterComponent.Kind) -> Bool
}
