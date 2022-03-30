//
//  InputNode.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Joystick: SKSpriteNode {
    private unowned var responder: InputResponder?
    private var active = false
    private var innerStickNode: SKSpriteNode?

    var displacement: CGVector?

    init(to responder: InputResponder) {
        self.responder = responder
        let position = CGConverter.sharedConverter.getScenePosition(for: PositionConstants.joystickPosition)
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.outerstickSize)
        super.init(
            texture: SKTexture(imageNamed: Images.outerStick.name),
            color: .clear,
            size: size)
        configureNode(at: position)
        addInnerStickNode()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              isValidTouch(touch)
        else { return }

        active = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard active,
              let touch = touches.first
        else { return }

        let locationInView = touch.location(in: scene?.camera ?? self)
        let angle = Self.angle(from: position, to: locationInView)
        let location = touch.location(in: self)

        let displacement = distance(to: location, along: angle)
        self.displacement = CGVector(dx: displacement.dx, dy: 0)
        moveInnerStickNode(to: location, along: angle)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard active else {
            return
        }

        resetInnerStickNodePosition()
        active = false
        displacement = nil
    }

    private func isValidTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        guard innerStickNode?.contains(location) ?? false else {
            return false
        }

        return true
    }

    private func configureNode(at position: CGPoint) {
        alpha = MiscConstants.opacityTwo
        isUserInteractionEnabled = true
        zPosition = DepthPosition.outerStick.rawValue
        self.position = position
    }

    private static func angle(from origin: CGPoint, to location: CGPoint) -> CGVector {
        let diff = CGVector(
            dx: location.x - origin.x,
            dy: location.y - origin.y)

        let angle = atan2(diff.dy, diff.dx)
        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return CGVector(dx: xAngle, dy: yAngle)
    }

    private func distance(to location: CGPoint, along angle: CGVector) -> CGVector {
        let innerStickDisplacement = innerStickNodeDisplacement(to: location)
        let x = angle.dx * innerStickDisplacement
        let y = angle.dy * innerStickDisplacement
        return CGVector(
            dx: -x * MiscConstants.speedMultiplier,
            dy: y * MiscConstants.speedMultiplier)
    }

    // MARK: - Inner Stick Modifiers
    private func innerStickNodeDisplacement(to location: CGPoint) -> CGFloat {
        CGPoint.zero.distance(to: location)
    }

    private func addInnerStickNode() {
        let node = SKSpriteNode(imageNamed: Images.innerStick.name)
        node.size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.innerstickSize)
        node.zPosition = DepthPosition.innerStick.rawValue
        innerStickNode = node
        addChild(node)
    }

    private func moveInnerStickNode(to location: CGPoint, along angle: CGVector) {
        if innerStickNodeDisplacement(to: location) <= size.width / 2 {
            innerStickNode?.position = location
        } else {
            innerStickNode?.position = CGPoint(
                x: -(angle.dx * size.width / 2),
                y: angle.dy * size.width / 2)
        }
    }

    private func resetInnerStickNodePosition() {
        innerStickNode?.position =  .zero
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
