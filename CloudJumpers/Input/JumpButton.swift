//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import UIKit
import RenderCore

class JumpButton: SpriteNodeCore {
    private unowned var responder: InputResponder?

    init(at position: CGPoint, to responder: InputResponder) {
        self.responder = responder
        super.init(
            texture: Texture.texture(of: Buttons.outerStick.frame),
            color: .clear,
            size: Constants.jumpButtonSize)
        configureNode(at: position)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              isValidTouch(touch)
        else { return }

        responder?.inputJump()
    }

    private func isValidTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: scene?.camera ?? self)
        return contains(location)
    }

    private func configureNode(at position: CGPoint) {
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.outerStick.rawValue
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
