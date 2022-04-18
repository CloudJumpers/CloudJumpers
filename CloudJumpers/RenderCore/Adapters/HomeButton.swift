//
//  HomeButton.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 18/4/22.
//

import SpriteKit

class HomeButton: SKSpriteNode {
    weak var delegate: HomeButtonDelegate?

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        isUserInteractionEnabled = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didPressHomeButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol HomeButtonDelegate: AnyObject {
    func didPressHomeButton()
}
