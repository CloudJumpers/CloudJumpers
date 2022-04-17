//
//  PowerUpEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

protocol PowerUpEffectCreator {
    init()

    func create(at location: CGPoint, activatorId: EntityID) -> Entity

    func doesMatch(type: PowerUpComponent.Kind) -> Bool
}
