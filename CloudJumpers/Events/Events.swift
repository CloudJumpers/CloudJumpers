//
//  Events.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

enum Events: Int, CaseIterable {
    case move
    case jump
    case animate
    case obtain
    case reposition

    static func type(of event: Event) -> Events? {
        switch event {
        case is MoveEvent:
            return .move
        case is JumpEvent:
            return .jump
        case is AnimateEvent:
            return .animate
        case is ObtainEvent:
            return .obtain
        case is RepositionEvent:
            return .reposition
        default:
            return nil
        }
    }
}
