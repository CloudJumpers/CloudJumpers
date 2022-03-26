//
//  ConfuseButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit

class ConfuseButton: PowerUpButton {
    init(at location: CGPoint, to inputResponder: InputResponder) {
        super.init(at: location, to: inputResponder, type: .confuse,
                   name: Images.confuse.name)
    }

    override func activatePowerUp(location: CGPoint) {
        guard isSet else {
            return
        }

        print("confuse \(location)")
    }
}
