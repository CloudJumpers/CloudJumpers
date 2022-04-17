//
//  ContactHandler.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

struct ContactHandler {
    static func between(_ player1: Player, _ player2: Player) -> Event? { nil }

    static func between(_ player: Player, _ powerUp: PowerUp) -> Event? {
        PowerUpPlayerCollideEvent(on: player.id, powerUp: powerUp.id)
    }

    static func between(_ player: Player, _ cloud: Cloud) -> Event? {
        ChangeStandOnLocationEvent(on: player.id, standOnEntityID: cloud.id)
    }

    static func between(_ player: Player, _ floor: Floor) -> Event? { nil }

    static func between(_ player: Player, _ platform: Platform) -> Event? {
        ChangeStandOnLocationEvent(on: player.id, standOnEntityID: platform.id)
 }

    static func between(_ player: Player, _ disaster: Disaster) -> Event? {
        DisasterPlayerCollideEvent(from: disaster.id, on: player.id)
    }

    static func between(_ player: Player, _ guest: Guest) -> Event? { nil }

    static func between(_ powerUp1: PowerUp, _ powerUp2: PowerUp) -> Event? { nil }

    static func between(_ powerUp: PowerUp, _ cloud: Cloud) -> Event? { nil }

    static func between(_ powerUp: PowerUp, _ floor: Floor) -> Event? { nil }

    static func between(_ powerUp: PowerUp, _ platform: Platform) -> Event? { nil }

    static func between(_ powerUp: PowerUp, _ disaster: Disaster) -> Event? { nil }

    static func between(_ powerUp: PowerUp, _ guest: Guest) -> Event? { nil }

    static func between(_ cloud1: Cloud, _ cloud2: Cloud) -> Event? { nil }

    static func between(_ cloud: Cloud, _ floor: Floor) -> Event? { nil }

    static func between(_ cloud: Cloud, _ platform: Platform) -> Event? { nil }

    static func between(_ cloud: Cloud, _ disaster: Disaster) -> Event? {
        RemoveEvent(onEntityWith: disaster.id)
    }

    static func between(_ cloud: Cloud, _ guest: Guest) -> Event? {
        ChangeStandOnLocationEvent(on: guest.id, standOnEntityID: cloud.id)
    }

    static func between(_ floor1: Floor, _ floor2: Floor) -> Event? { nil }

    static func between(_ floor: Floor, _ platform: Platform) -> Event? { nil }

    static func between(_ floor: Floor, _ disaster: Disaster) -> Event? {
        RemoveEvent(onEntityWith: disaster.id)
    }

    static func between(_ floor: Floor, _ guest: Guest) -> Event? { nil }

    static func between(_ platform1: Platform, _ platform2: Platform) -> Event? { nil }

    static func between(_ platform: Platform, _ disaster: Disaster) -> Event? {
        RemoveEvent(onEntityWith: disaster.id)
    }

    static func between(_ platform: Platform, _ guest: Guest) -> Event? {
        ChangeStandOnLocationEvent(on: guest.id, standOnEntityID: platform.id)
    }

    static func between(_ disaster1: Disaster, _ disaster2: Disaster) -> Event? { nil }

    static func between(_ disaster: Disaster, _ guest: Guest) -> Event? { nil }

    static func between(_ guest1: Guest, _ guest2: Guest) -> Event? { nil }
}
