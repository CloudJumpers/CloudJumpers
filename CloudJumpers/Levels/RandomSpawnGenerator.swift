//
//  RandomSpawnGenerator.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class RandomSpawnGenerator {
    static func isSpawning(successRate: Float) -> Bool {
        Float.random(in: 0..<100) < successRate
    }

    // TODO: USE Blueprint on this
    static func getRandomVector(blueprint: Blueprint) -> CGVector {
        let xDir = Double.random(between: Constants.disasterMinXDirection, and: Constants.disasterMaxXDirection)
        let yDir = Double.random(between: Constants.disasterMinYDirection, and: Constants.disasterMaxYDirection)
        let velocity = Double.random(between: Constants.disasterMinSpeed, and: Constants.disasterMaxSpeed)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    static func getRandomPosition(blueprint: Blueprint) -> CGPoint {
        let width = blueprint.worldSize.width
        let maxHeight = blueprint.worldSize.height
        return CGPoint(
            x: Double.random(between: -width / 2, and: width / 2),
            y: Double.random(between: blueprint.firstPlatformPosition.y, and: maxHeight))
    }

    static func getRandomDisasterType() -> DisasterComponent.Kind? {
        DisasterComponent.Kind.allCases.randomElement()
    }

    static func getRandomPowerType() -> PowerUpComponent.Kind? {
        PowerUpComponent.Kind.allCases.randomElement()
    }
}
