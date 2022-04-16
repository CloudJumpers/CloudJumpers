//
//  RandomPositionGenerationInfo.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

struct RandomPositionGenerationInfo {
    let worldSize: CGSize
    let positionXRange: ClosedRange<Float>
    let firstPlatformPosition: CGPoint
}
