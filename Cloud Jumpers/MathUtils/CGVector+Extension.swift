//
//  CGVector+Extension.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import CoreGraphics
extension CGVector {
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }

    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    static func += (lhs: inout CGVector, rhs: CGVector) {
        let sumVector = lhs + rhs
        lhs = sumVector
    }

    func dot(with vector: CGVector) -> CGFloat {
        self.dx * vector.dx + self.dy * vector.dy
    }

    func angle() -> CGFloat {
        atan2(dx, dy)
    }

    func normalized() -> CGVector {
        self / self.magnitude()
    }

    func magnitude() -> CGFloat {
        .squareRoot(dx * dx + dy * dy)()
    }

    func reversed() -> CGVector {
        CGVector(dx: -self.dx, dy: -self.dy)
    }

    func scaleToUnit(with frame: CGRect) -> CGVector {
        let scaleFactor = CGAffineTransform(scaleX: 1 / frame.maxX, y: 1 / frame.maxX)
        return self.applying(scaleFactor)
    }

    func scaleToSize(with frame: CGRect) -> CGVector {
        let scaleFactor = CGAffineTransform(scaleX: frame.maxX, y: frame.maxX)
        return self.applying(scaleFactor)
    }

    func applying(_ scaleFactor: CGAffineTransform) -> CGVector {
        let point = CGPoint(x: self.dx, y: self.dy).applying(scaleFactor)
        return CGVector(dx: point.x, dy: point.y)
    }
}
