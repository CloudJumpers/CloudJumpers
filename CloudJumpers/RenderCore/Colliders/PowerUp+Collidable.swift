//
//  PowerUp+Collidable.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/4/22.
//

import Foundation

extension PowerUp {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collides(with: self)
    }

    func collides(with player: Player) -> Event? {
        ContactHandler.between(player, self)
    }

    func collides(with powerUp: PowerUp) -> Event? {
        ContactHandler.between(self, powerUp)
    }

    func collides(with cloud: Cloud) -> Event? {
        ContactHandler.between(self, cloud)
    }

    func collides(with floor: Floor) -> Event? {
        ContactHandler.between(self, floor)
    }

    func collides(with platform: Platform) -> Event? {
        ContactHandler.between(self, platform)
    }

    func collides(with wall: Wall) -> Event? {
        ContactHandler.between(self, wall)
    }

    func collides(with disaster: Disaster) -> Event? {
        ContactHandler.between(self, disaster)
    }

    func collides(with guest: Guest) -> Event? {
        ContactHandler.between(self, guest)
    }
}
