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
    private(set) var imageName: String
    private var label: SKLabelNode?

    init(at position: CGPoint, to responder: InputResponder, type: PowerUpType, name: String) {
        self.responder = responder
        self.type = type
        self.imageName = name
        super.init(
            texture: SKTexture(imageNamed: name),
            color: .clear,
            size: Constants.powerUpButtonSize)
        configureNode(at: position)
        addQuantityLabelNode()
    }

    func increaseQuantity() {
        guard quantity < 9 else {
            return
        }

        quantity += 1
        label?.text = "\(quantity)"
    }

    func decreaseQuantity() {
        guard quantity > 0 else {
            return
        }

        quantity -= 1
        label?.text = "\(quantity)"
    }

    func set(_ set: Bool) {
        self.isSet = set
        alpha = self.isSet ? Constants.fullOpacity : Constants.opacityTwo
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

    private func addQuantityLabelNode() {
        let node = SKLabelNode(fontNamed: "AvenirNext-Bold")
        node.text = "\(quantity)"
        node.fontSize = 30.0
        node.fontColor = .red
        node.position = CGPoint(x: 0.0, y: 0.0)
        node.zPosition = SpriteZPosition.text.rawValue
        label = node

        addChild(node)
    }

    private func configureNode(at position: CGPoint) {
        isUserInteractionEnabled = true
        zPosition = SpriteZPosition.button.rawValue
        alpha = Constants.opacityTwo
        self.position = position

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
