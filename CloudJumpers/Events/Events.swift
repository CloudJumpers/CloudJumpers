//
//  Events.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

enum Events: Int, CaseIterable {
    case move
    case jump
    case animateIdle
    case animateWalking
    case animateJumping

    func type(of event: Event) -> Events? {
        switch event {
        case is MoveEvent:
            return .move
        case is JumpEvent:
            return .jump
        default:
            return nil
        }
    }
}
