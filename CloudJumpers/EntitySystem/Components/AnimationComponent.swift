//
//  AnimationComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

typealias AnimationKey = String
typealias AnimationFrames = [TextureFrame]
typealias Animation = (key: AnimationKey, frames: AnimationFrames)

class AnimationComponent: Component {
    var animations: [AnimationKey: AnimationFrames]
    var activeAnimation: Animation?

    override init() {
        animations = [:]
    }
}
