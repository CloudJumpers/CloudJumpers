//
//  Events.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

enum Events: Int {
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
    case confuse
    case freeze
    case powerUpEffectStart
    case reposition
    case respawn
    case disasterHit
    case blinkEffect
    case disasterStart
    case respawnEffect
    case disasterPromptEffect
    case disasterSpawn

    private static let events: [String: Events] = [
        String(describing: BiEvent.self): .bi,
        String(describing: LogEvent.self): .log,
        String(describing: MoveEvent.self): .move,
        String(describing: JumpEvent.self): .jump,
        String(describing: AnimateEvent.self): .animate,
        String(describing: PowerUpCollideEvent.self): .powerUpCollide,
        String(describing: ObtainEvent.self): .obtain,
        String(describing: RemoveEntityEvent.self): .removeEntity,
        String(describing: ActivatePowerUpEvent.self): .activatePowerUp,
        String(describing: RepositionEvent.self): .reposition,
        String(describing: RemoveUnboundEntityEvent.self): .removeUnboundEntity,
        String(describing: DisasterHitEvent.self): .disasterHit,
        String(describing: BlinkEffectEvent.self): .blinkEffect,
        String(describing: DisasterStartEvent.self): .disasterStart,
        String(describing: RespawnEvent.self): .respawn,
        String(describing: RespawnEffectEvent.self): .respawnEffect,
        String(describing: DisasterPromptEffectEvent.self): .disasterPromptEffect,
        String(describing: DisasterSpawnEvent.self): .disasterSpawn,
        String(describing: ConfuseEvent.self): .confuse,
        String(describing: FreezeEvent.self): .freeze
    ]

    static func rank(of event: Event) -> Int? {
        events[String(describing: type(of: event))]?.rawValue
    }
}
