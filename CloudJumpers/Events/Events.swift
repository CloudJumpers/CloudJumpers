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
    case changeStandOnLocation
    case updateGuestState
    case joystickUpdate
    case powerUpLocationPressed
    case jumpButtonPressed
    case powerUpActivate
    case disasterActivate
    case kill
    case powerUpSpawn
    case reposition
    case respawn
    case disasterPlayerCollide
    case sound
    case promoteGod
    case demoteGod
    case opacityChange
    case godPowerUpSpawn
    case disastersToggle

    private static let events: [String: Events] = [
        BiEvent.type: .bi,
        LogEvent.type: .log,
        MoveEvent.type: .move,
        JumpEvent.type: .jump,
        AnimateEvent.type: .animate,
        PowerUpSpawnEvent.type: .powerUpSpawn,
        PowerUpPlayerCollideEvent.type: .powerUpPlayerCollide,
        ObtainEvent.type: .obtain,
        RemoveEvent.type: .remove,
        PowerUpActivateEvent.type: .powerUpActivate,
        RepositionEvent.type: .reposition,
        DisasterPlayerCollideEvent.type: .disasterPlayerCollide,
        DisasterSpawnEvent.type: .disasterActivate,
        RespawnEvent.type: .respawn,
        ChangeStandOnLocationEvent.type: .changeStandOnLocation,
        SoundEvent.type: .sound,
        UpdateGuestStateEvent.type: .updateGuestState,
        KillEvent.type: .kill,
        JoystickUpdateEvent.type: .joystickUpdate,
        PowerUpLocationPressedEvent.type: .powerUpLocationPressed,
        JumpButtonPressedEvent.type: .jumpButtonPressed,
        PromoteGodEvent.type: .promoteGod,
        DemoteGodEvent.type: .demoteGod,
        OpacityChangeEvent.type: .opacityChange,
        GodPowerUpSpawnEvent.type: .godPowerUpSpawn
    ]

    static func rank(of event: Event) -> Int? {
        events[type(of: event).type]?.rawValue
    }
}
