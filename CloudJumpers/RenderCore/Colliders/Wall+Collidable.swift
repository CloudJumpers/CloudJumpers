//
//  Wall+Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Wall: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collides(with: self)
    }

    func collides(with player: Player) -> Event? {
        ContactHandler.between(player, self)
    }

    func collides(with powerUp: PowerUp) -> Event? {
        ContactHandler.between(powerUp, self)
    }

    func collides(with cloud: Cloud) -> Event? {
        ContactHandler.between(cloud, self)
    }

    func collides(with floor: Floor) -> Event? {
        ContactHandler.between(floor, self)
    }

    func collides(with platform: Platform) -> Event? {
        ContactHandler.between(platform, self)
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
