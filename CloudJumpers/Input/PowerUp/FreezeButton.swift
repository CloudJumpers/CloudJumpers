//
//  FreezeButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit

class FreezeButton: PowerUpButton {
    init(at location: CGPoint, to inputResponder: InputResponder) {
        super.init(at: location, to: inputResponder, type: .freeze, name: Images.freeze.name)
    }

    override func activatePowerUp(location: CGPoint) {
        guard isSet else {
            return
        }

        print("freeze \(location)")
    }
}
