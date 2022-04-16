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

    static func getRandomVelocity(_ velocityGenerationInfo: RandomVelocityGenerationInfo) -> CGVector {
        LevelGenerator.getRandomVelocity(velocityGenerationInfo)
    }

    static func getRandomPosition(_ positionGenerationInfo: RandomPositionGenerationInfo) -> CGPoint {
        LevelGenerator.getRandomPosition(positionGenerationInfo)
    }

    static func getRandomDisasterType() -> DisasterComponent.Kind? {
        DisasterComponent.Kind.allCases.randomElement()
    }

    static func getRandomPowerType() -> PowerUpComponent.Kind? {
        PowerUpComponent.Kind.allCases.randomElement()
    }
}
