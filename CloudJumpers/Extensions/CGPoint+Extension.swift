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
}

// MARK: Vector-related
extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGVector) {
        let sumPoint = lhs + rhs
        lhs = sumPoint
    }
}
