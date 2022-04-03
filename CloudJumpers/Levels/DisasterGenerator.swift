//
//  DisasterGenerator.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import Foundation
import CoreGraphics
class DisasterGenerator {
    static func createRandomDisaster(within highestHeight: CGFloat) -> DisasterInformation? {
        guard getProbabilisticSuccess(successRate: 1) else {
            return nil
        }

        let randomPosition = getRandomPosition(within: highestHeight)
        let randomVelocity = getRandomVelocity()
        let disasterType = getRandomType() ?? .meteor

        return DisasterInformation(position: randomPosition,
                                   velocity: randomVelocity,
                                   type: disasterType)
    }

    static func getRandomVelocity() -> CGVector {
        let xDir = Double.random(between: -1, and: 1)
        let yDir = Double.random(between: -1, and: 0)
        let velocity = Double.random(between: 100, and: 170)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    static func getRandomPosition(within maxY: CGFloat) -> CGPoint {
        CGPoint(
            x: Double.random(between: -300, and: 300),
            y: Double.random(between: -100, and: maxY - 100))
    }

    static func getProbabilisticSuccess(successRate: Int) -> Bool {
        Int.random(in: 0..<100) < successRate
    }

    static func getRandomType() -> DisasterComponent.Kind? {
        DisasterComponent.Kind.allCases.randomElement()
    }
}

struct DisasterInformation {
    var position: CGPoint
    var velocity: CGVector
    var type: DisasterComponent.Kind
}
