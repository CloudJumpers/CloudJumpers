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
        guard getProbabilisticSuccess(successRate: Constants.disasterGenerationProbability) else {
            return nil
        }

        let randomPosition = getRandomPosition(within: highestHeight)
        let randomVelocity = getRandomVelocity()
        let disasterType = getRandomType() ?? .meteor

        return DisasterInformation(position: randomPosition,
                                   velocity: randomVelocity,
                                   type: disasterType)
    }

    private static func getRandomVelocity() -> CGVector {
        let xDir = Double.random(between: Constants.disasterMinXDirection, and: Constants.disasterMaxXDirection)
        let yDir = Double.random(between: Constants.disasterMinYDirection, and: Constants.disasterMaxYDirection)
        let velocity = Double.random(between: Constants.disasterMinSpeed, and: Constants.disasterMaxSpeed)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private static func getRandomPosition(within maxY: CGFloat) -> CGPoint {
        CGPoint(
            x: Double.random(between: -Constants.screenWidth / 2, and: Constants.screenWidth / 2),
            y: Double.random(between: Constants.disasterMinYPosition, and: maxY - Constants.disasterYPositionOffset))
    }

    private static func getProbabilisticSuccess(successRate: Int) -> Bool {
        Int.random(in: 0..<100) < successRate
    }

    private static func getRandomType() -> DisasterComponent.Kind? {
        DisasterComponent.Kind.allCases.randomElement()
    }
}

struct DisasterInformation {
    var position: CGPoint
    var velocity: CGVector
    var type: DisasterComponent.Kind
}
