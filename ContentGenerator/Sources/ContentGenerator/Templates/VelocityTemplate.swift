//
//  VelocityTemplate.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 16/4/22.
//

import Foundation

public struct VelocityTemplate {
    let velocityRange: ClosedRange<Float>
    let seed: Int

    public init(velocityRange: ClosedRange<Float>, seed: Int) {
        self.velocityRange = velocityRange
        self.seed = seed
    }
}
