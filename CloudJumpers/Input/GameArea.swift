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
            texture: SKTexture(),
            color: .red,
            size: Constants.gameAreaSize)

        configureNode(at: position)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene?.touchesBegan(touches, with: event)

        guard let touch = touches.first,
              isValidTouch(touch)
        else { return }

        let location = touch.location(in: self)
        responder?.activatePowerUp(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene?.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene?.touchesEnded(touches, with: event)
    }

    private func isValidTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        return contains(location)
    }

    private func configureNode(at position: CGPoint) {
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.background.rawValue
        alpha = 0.01
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
