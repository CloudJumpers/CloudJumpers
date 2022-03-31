//
//  LevelGenerator.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 28/3/22.
//

import CoreGraphics
import GameplayKit

class LevelGenerator {
    static func from(_ blueprint: Blueprint, seed: Int) -> [CGPoint] {
        var generator = SeedGenerator(seed: seed)
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

    private static func random(in range: ClosedRange<Float>, using generator: inout SeedGenerator) -> CGFloat {
        CGFloat(Float.random(in: range, using: &generator))
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
