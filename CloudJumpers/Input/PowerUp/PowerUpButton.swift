//
//  PowerUpButton.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit

class PowerUpButton: SKSpriteNode {
    private unowned var responder: InputResponder?
    private var type: PowerUpType
    private(set) var quantity: Int = 0
    private(set) var isSet = false

    init(at position: CGPoint, to responder: InputResponder, type: PowerUpType, name: String) {
        self.responder = responder
        self.type = type
        super.init(
            texture: SKTexture(imageNamed: name),
            color: .clear,
            size: Constants.powerUpButtonSize)
        configureNode(at: position)
    }

    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantity() {
        quantity -= 1
    }

    func set(_ set: Bool) {
        self.isSet = set
        alpha = self.isSet ? Constants.fullOpacity : Constants.opacityOne
    }

    func activatePowerUp(location: CGPoint) { }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              isValidTouch(touch)
        else { return }

        responder?.setPowerUp(powerUp: self)
    }

    private func isValidTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: scene?.camera ?? self)
        return contains(location)
    }

    private func configureNode(at position: CGPoint) {
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.outerStick.rawValue
        alpha = Constants.opacityOne
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
