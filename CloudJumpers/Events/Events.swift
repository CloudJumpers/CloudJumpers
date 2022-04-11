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
    case powerUpPlayerCollide
    case obtain
    case remove
    case powerUpActivate
    case confuse
    case freeze
    case powerUpEffectStart
    case reposition
    case respawn
    case disasterPlayerCollide
    case blinkEffect
    case disasterActivate
    case changeLocation
    case sound
    case updateState

    private static let events: [String: Events] = [
        String(describing: BiEvent.self): .bi,
        String(describing: LogEvent.self): .log,
        String(describing: MoveEvent.self): .move,
        String(describing: JumpEvent.self): .jump,
        String(describing: AnimateEvent.self): .animate,
        String(describing: PowerUpPlayerCollideEvent.self): .powerUpPlayerCollide,
        String(describing: ObtainEvent.self): .obtain,
        String(describing: RemoveEvent.self): .remove,
        String(describing: PowerUpActivateEvent.self): .powerUpActivate,
        String(describing: RepositionEvent.self): .reposition,
        String(describing: DisasterPlayerCollideEvent.self): .disasterPlayerCollide,
        String(describing: BlinkEvent.self): .blinkEffect,
        String(describing: DisasterActivateEvent.self): .disasterActivate,
        String(describing: RespawnEvent.self): .respawn,
        String(describing: ChangeStandOnLocationEvent.self): .changeLocation,
        String(describing: SoundEvent.self): .sound,
        String(describing: UpdateGuestStateEvent.self): .updateState,
        String(describing: ConfuseEvent.self): .confuse,
        String(describing: FreezeEvent.self): .freeze
    ]

    static func rank(of event: Event) -> Int? {
        events[String(describing: type(of: event))]?.rawValue
    }
}
