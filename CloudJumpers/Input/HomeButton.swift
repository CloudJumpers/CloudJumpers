//
//  HomeButton.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 18/4/22.
//

import UIKit
import RenderCore

class HomeButton: SpriteNodeCore {
    weak var delegate: HomeButtonDelegate?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didPressHomeButton()
    }

    func configure(at position: CGPoint) {
        self.position = position
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.hud.rawValue
    }
}

protocol HomeButtonDelegate: AnyObject {
    func didPressHomeButton()
}
