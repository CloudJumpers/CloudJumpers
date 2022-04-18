//
//  DisasterTransformComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

class DisasterTransformComponent: Component {
    let kind: DisasterComponent.Kind
    let position: CGPoint
    let velocity: CGVector
    let disasterTexture: Miscellaneous
    let timeToTransform: TimeInterval

    init(kind: DisasterComponent.Kind, position: CGPoint, velocity: CGVector,
         disasterTexture: Miscellaneous, after timeToTransform: TimeInterval) {
        self.kind = kind
        self.position = position
        self.velocity = velocity
        self.timeToTransform = timeToTransform
        self.disasterTexture = disasterTexture
        super.init()
    }
}
