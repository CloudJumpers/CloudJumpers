//
//  GameArea.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit

class GameArea: SKSpriteNode {
    private unowned var responder: InputResponder?

    init(at position: CGPoint, to responder: InputResponder) {
        self.responder = responder
        super.init(
            texture: SKTexture(imageNamed: Images.background.name),
            color: .clear,
            size: Constants.gameAreaSize)
        configureNode(at: position)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              isValidTouch(touch)
        else { return }

        responder?.activatePowerUp(touchLocation: touch.location(in: scene?.camera ?? self))
    }

    private func isValidTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: scene?.camera ?? self)
        return contains(location)
    }

    private func configureNode(at position: CGPoint) {
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.outerStick.rawValue
        alpha = 0.01
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
