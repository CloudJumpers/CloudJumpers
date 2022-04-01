//
//  Events.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

enum Events: Int, CaseIterable {
    case bi
    case log
    case move
    case jump
    case animate
    case obtain
    case removeEntity
    case activatePowerUp
    case reposition
    case disasterHit
    case generateDisaster

    // swiftlint:disable cyclomatic_complexity
    static func type(of event: Event) -> Events? {
        switch event {
        case is BiEvent:
            return .bi
        case is LogEvent:
            return .log
        case is MoveEvent:
            return .move
        case is JumpEvent:
            return .jump
        case is AnimateEvent:
            return .animate
        case is ObtainEvent:
            return .obtain
        case is RemoveEntityEvent:
            return .removeEntity
        case is ActivatePowerUpEvent:
            return .activatePowerUp
        case is RepositionEvent:
            return .reposition
        case is DisasterHitEvent:
            return .disasterHit
        case is GenerateDisasterEvent:
            return .generateDisaster
        default:
            return nil
        }
    }
}
