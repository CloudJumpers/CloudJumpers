//
//  JumpButton.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class JumpButton: SKSpriteNode {
    private unowned var responder: InputResponder?

    init(to responder: InputResponder) {
        let position = CGConverter.sharedConverter.getScenePosition(for: PositionConstants.jumpButtonPosition)
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.jumpButtonSize)
        self.responder = responder
        super.init(
            texture: SKTexture(imageNamed: Images.outerStick.name),
            color: .clear,
            size: size)
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
        zPosition = DepthPosition.outerStick.rawValue
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
