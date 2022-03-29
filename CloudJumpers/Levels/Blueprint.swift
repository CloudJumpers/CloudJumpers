//
//  Blueprint.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 28/3/22.
//

import CoreGraphics

struct Blueprint {
    let worldSize: CGSize
    let platformSize: CGSize
    let tolerance: CGVector
    let xToleranceRange: ClosedRange<Float>
    let yToleranceRange: ClosedRange<Float>
    let firstPlatformPosition: CGPoint
}

// MARK: - Codable
extension Blueprint: Codable {
}
