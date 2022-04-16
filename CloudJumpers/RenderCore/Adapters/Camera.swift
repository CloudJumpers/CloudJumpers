//
//  Camera.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/4/22.
//

import SpriteKit

class Camera: SKCameraNode {
    private let minY: CGFloat
    private let maxY: CGFloat

    var lastPosition: CGPoint?

    init(minY: CGFloat, maxY: CGFloat) {
        self.minY = minY
        self.maxY = maxY
        super.init()
        applyVerticalConstraint()
        setUpPhysicsBody()
    }

    func panVertically(to position: CGPoint) {
        self.position.y = position.y
    }

    func panVertically(by displacement: CGFloat) {
        self.position.y += displacement
    }

    func stopInertia() {
        physicsBody?.velocity = .zero
    }

    func easeWithInertia(by displacement: CGFloat) {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: displacement))
    }

    private func applyVerticalConstraint() {
        let range = SKRange(lowerLimit: minY, upperLimit: maxY)
        let constraint = SKConstraint.positionY(range)
        constraints = [constraint]
    }

    private func setUpPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        physicsBody?.collisionBitMask = 0x0
        physicsBody?.categoryBitMask = 0x0
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 2.0
    }

    @available(*, unavailable)
    override init() {
        fatalError("init() has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
