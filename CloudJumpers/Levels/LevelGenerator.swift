//
//  LevelGenerator.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 28/3/22.
//

import CoreGraphics
import GameplayKit

class LevelGenerator {
    static func positionFrom(_ blueprint: Blueprint) -> [CGPoint] {
        var generator = SeedGenerator(seed: blueprint.seed)
        var positions: [CGPoint] = []

        let xMax = blueprint.worldSize.width / 2 - blueprint.platformSize.width
        let xMin = -xMax

        var generatedWidth = blueprint.firstPlatformPosition.x
        var generatedHeight = blueprint.firstPlatformPosition.y
        var toggle = CGFloat.zero

        while generatedHeight < blueprint.worldSize.height {
            while generatedWidth < xMax {
                let yVarianceRatio = random(in: blueprint.yToleranceRange, using: &generator)
                let position = CGPoint(x: generatedWidth, y: generatedHeight + yVarianceRatio * blueprint.tolerance.dy)
                positions.append(position)

                let xToleranceRatio = random(in: blueprint.xToleranceRange, using: &generator)
                generatedWidth += blueprint.platformSize.width + (xToleranceRatio * blueprint.tolerance.dx)
            }

            let yToleranceRatio = random(in: blueprint.yToleranceRange, using: &generator)
            generatedHeight += blueprint.platformSize.height + (yToleranceRatio * blueprint.tolerance.dy)
            generatedWidth = xMin + (toggle * yToleranceRatio * blueprint.platformSize.width)
            toggle = (toggle + 1).remainder(dividingBy: 2)
        }

        return positions
    }

    static func velocityFrom(_ velocityGenerationInfo: VelocityGenerationInfo, size: Int) -> [CGFloat] {
        var generator = SeedGenerator(seed: velocityGenerationInfo.seed)
        var velocities: [CGFloat] = []

        while velocities.count < size {
            let shouldMove = random(in: 0.0...1.0, using: &generator) >= 0.5

            if !shouldMove {
                velocities.append(.zero)
            } else {
                let randomSpeed = random(in: velocityGenerationInfo.velocityRange, using: &generator)
                velocities.append(randomSpeed)
            }
        }

        return velocities
    }

    static func getRandomPosition(_ positionGenerationInfo: RandomPositionGenerationInfo) -> CGPoint {
        let randomSeed = getRandomSeed()
        var generator = SeedGenerator(seed: randomSeed)

        let xMax = Float(positionGenerationInfo.worldSize.width / 2)
        let xMin = Float(-xMax)

        let yMax = Float(positionGenerationInfo.worldSize.height)
        let yMin = Float(-100.0)

        let positionX = random(in: xMin...xMax, using: &generator)
        let positionY = random(in: yMin...yMax, using: &generator)

        return CGPoint(x: positionX, y: positionY)
    }

    static func getRandomVelocity(_ velocityGenerationInfo: RandomVelocityGenerationInfo) -> CGVector {
        let randomSeed = getRandomSeed()
        var generator = SeedGenerator(seed: randomSeed)

        let xVelocity = random(in: velocityGenerationInfo.xRange, using: &generator)
        let yVelocity = random(in: velocityGenerationInfo.yRange, using: &generator)
        let speed = random(in: velocityGenerationInfo.speedRange, using: &generator)

        return CGVector(dx: speed * xVelocity, dy: speed * yVelocity)
    }

    private static func random(in range: ClosedRange<Float>, using generator: inout SeedGenerator) -> CGFloat {
        CGFloat(Float.random(in: range, using: &generator))
    }

    private static func getRandomSeed() -> Int {
        Int.random(in: 1..<1_000_000_000)
    }
}

// MARK: - SeedGenerator
private struct SeedGenerator: RandomNumberGenerator {
    init(seed: Int) {
        srand48(seed)
    }

    // swiftlint:disable legacy_random
    func next() -> UInt64 {
        withUnsafeBytes(of: drand48()) { $0.load(as: UInt64.self) }
    }
    // swiftlint:enable legacy_random
}
