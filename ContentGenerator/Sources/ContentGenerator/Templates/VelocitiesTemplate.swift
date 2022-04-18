//
//  VelocitiesTemplate.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation

public struct VelocitiesTemplate {
    let xRange: ClosedRange<Float>
    let yRange: ClosedRange<Float>
    let speedRange: ClosedRange<Float>

    public init(
        xRange: ClosedRange<Float>,
        yRange: ClosedRange<Float>,
        within speedRange: ClosedRange<Float>
    ) {
        self.xRange = xRange
        self.yRange = yRange
        self.speedRange = speedRange
    }
}
