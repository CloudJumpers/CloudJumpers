//
//  ContactHandler.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

struct ContactHandler {
    static func between(_ player1: Player, _ player2: Player) -> Event? { return nil }
    static func between(_ player: Player, _ powerUp: PowerUp) -> Event? { return nil }
    static func between(_ player: Player, _ cloud: Cloud) -> Event? { return nil }
    static func between(_ player: Player, _ floor: Floor) -> Event? { return nil }
    static func between(_ player: Player, _ platform: Platform) -> Event? { return nil }
    static func between(_ player: Player, _ wall: Wall) -> Event? { return nil }
    static func between(_ player: Player, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ player: Player, _ guest: Guest) -> Event? { return nil }
    static func between(_ powerUp1: PowerUp, _ powerUp2: PowerUp) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ cloud: Cloud) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ floor: Floor) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ platform: Platform) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ wall: Wall) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ powerUp: PowerUp, _ guest: Guest) -> Event? { return nil }
    static func between(_ cloud1: Cloud, _ cloud2: Cloud) -> Event? { return nil }
    static func between(_ cloud: Cloud, _ floor: Floor) -> Event? { return nil }
    static func between(_ cloud: Cloud, _ platform: Platform) -> Event? { return nil }
    static func between(_ cloud: Cloud, _ wall: Wall) -> Event? { return nil }
    static func between(_ cloud: Cloud, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ cloud: Cloud, _ guest: Guest) -> Event? { return nil }
    static func between(_ floor1: Floor, _ floor2: Floor) -> Event? { return nil }
    static func between(_ floor: Floor, _ platform: Platform) -> Event? { return nil }
    static func between(_ floor: Floor, _ wall: Wall) -> Event? { return nil }
    static func between(_ floor: Floor, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ floor: Floor, _ guest: Guest) -> Event? { return nil }
    static func between(_ platform1: Platform, _ platform2: Platform) -> Event? { return nil }
    static func between(_ platform: Platform, _ wall: Wall) -> Event? { return nil }
    static func between(_ platform: Platform, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ platform: Platform, _ guest: Guest) -> Event? { return nil }
    static func between(_ wall1: Wall, _ wall2: Wall) -> Event? { return nil }
    static func between(_ wall: Wall, _ disaster: Disaster) -> Event? { return nil }
    static func between(_ wall: Wall, _ guest: Guest) -> Event? { return nil }
    static func between(_ disaster1: Disaster, _ disaster2: Disaster) -> Event? { return nil }
    static func between(_ disaster: Disaster, _ guest: Guest) -> Event? { return nil }
    static func between(_ guest1: Guest, _ guest2: Guest) -> Event? { return nil }
}
