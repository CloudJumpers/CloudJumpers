//
//  CGPoint+Extension.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import CoreGraphics

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    func distance(to point: CGPoint) -> CGFloat {
        let distanceVector: CGVector = self - point
        return distanceVector.magnitude()
    }

    func magnitude() -> CGFloat {
        .squareRoot((x * x) + (y * y))()
    }

    func scaleToUnit(with frame: CGRect) -> CGPoint {
        let scaleFactor = CGAffineTransform(scaleX: 1 / frame.maxX, y: 1 / frame.maxX)
        return self.applying(scaleFactor)
    }

    func scaleToSize(with frame: CGRect) -> CGPoint {
        let scaleFactor = CGAffineTransform(scaleX: frame.maxX, y: frame.maxX)
        return self.applying(scaleFactor)
    }

    func rotate(around point: CGPoint, by angle: CGFloat) -> CGPoint {
        let translate = CGAffineTransform(translationX: point.x, y: point.y)
        let rotate = CGAffineTransform(rotationAngle: angle)
        return self.applying(translate.inverted().concatenating(rotate).concatenating(translate))
    }

    func reversedVerticalDirection() -> CGPoint {
        CGPoint(x: self.x, y: -self.y)
    }
}

// MARK: Vector- related
extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    // Maybe the other way around
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGVector) {
        let sumPoint = lhs + rhs
        lhs = sumPoint
    }
}
