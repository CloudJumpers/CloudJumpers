//
//  RandomSpawnGenerator.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import CoreGraphics

public class RandomSpawnGenerator {
    public static func isSpawning(successRate: Float) -> Bool {
        Float.random(in: 0..<100) < successRate
    }

    public static func getRandomVelocity(_ velocitiesTemplate: VelocitiesTemplate) -> CGVector {
        LevelGenerator.getRandomVelocity(velocitiesTemplate)
    }

    public static func getRandomPosition(_ positionsTemplate: PositionsTemplate) -> CGPoint {
        LevelGenerator.getRandomPosition(positionsTemplate)
    }
}
