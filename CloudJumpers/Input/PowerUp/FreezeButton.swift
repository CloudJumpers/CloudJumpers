//
//  FreezeButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit

class FreezeButton: PowerUpButton {
    init(at location: CGPoint, powerUpManager: PowerUpManager, eventManger: EventManager) {
        super.init(at: location, powerUpManager: powerUpManager,
                   eventManager: eventManger, type: .freeze, name: Images.freeze.name)
    }
}
