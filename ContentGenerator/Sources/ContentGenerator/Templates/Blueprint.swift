//
//  Blueprint.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 28/3/22.
//

import CoreGraphics

public struct Blueprint {
    let worldSize: CGSize
    let platformSize: CGSize
    let tolerance: CGVector
    let xToleranceRange: ClosedRange<Float>
    let yToleranceRange: ClosedRange<Float>
    let firstPlatformPosition: CGPoint
    let seed: Int

    public init(
        worldSize: CGSize,
        platformSize: CGSize,
        tolerance: CGVector,
        xToleranceRange: ClosedRange<Float>,
        yToleranceRange: ClosedRange<Float>,
        firstPlatformPosition: CGPoint,
        seed: Int
    ) {
        self.worldSize = worldSize
        self.platformSize = platformSize
        self.tolerance = tolerance
        self.xToleranceRange = xToleranceRange
        self.yToleranceRange = yToleranceRange
        self.firstPlatformPosition = firstPlatformPosition
        self.seed = seed
    }
}

// MARK: - Codable
extension Blueprint: Codable {
}
