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
    case powerUpCollide
    case obtain
    case removeEntity
    case removeUnboundEntity
    case activatePowerUp
    case powerUpEffectStart
    case reposition
    case respawn
    case disasterHit
    case generateDisaster
    case blinkEffect
    case conditional
    case disasterStart
    case respawnEffect
    case disasterPromptEffect
    case disasterSpawn

    static let events: [String: Events] = [
        String(describing: BiEvent.self): .bi,
        String(describing: LogEvent.self): .log,
        String(describing: MoveEvent.self): .move,
        String(describing: JumpEvent.self): .jump,
        String(describing: AnimateEvent.self): .animate,
        String(describing: PowerUpCollideEvent.self): .powerUpCollide,
        String(describing: ObtainEvent.self): .obtain,
        String(describing: RemoveEntityEvent.self): .removeEntity,
        String(describing: ActivatePowerUpEvent.self): .activatePowerUp,
        String(describing: PowerUpEffectStartEvent.self): .powerUpEffectStart,
        String(describing: RepositionEvent.self): .reposition,
        String(describing: RemoveUnboundEntityEvent.self): .removeUnboundEntity,
        String(describing: DisasterHitEvent.self): .disasterHit,
        String(describing: GenerateDisasterEvent.self): .generateDisaster,
        String(describing: BlinkEffectEvent.self): .blinkEffect,
        String(describing: DisasterStartEvent.self): .disasterStart,
        String(describing: RespawnEvent.self): .respawn,
        String(describing: RespawnEffectEvent.self): .respawnEffect,
        String(describing: DisasterPromptEffectEvent.self): .disasterPromptEffect,
        String(describing: DisasterSpawnEvent.self): .disasterSpawn

    ]

    static func eventType(for event: Event) -> Events? {
        events[String(describing: type(of: event.self))]
    }
}
