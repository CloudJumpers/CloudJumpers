//
//  Wall+Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Wall: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        return collidable.collides(with: self)
    }

    func collides(with player: Player) -> Event? {
        return ContactHandler.between(player, self)
    }

    func collides(with powerUp: PowerUp) -> Event? {
        return ContactHandler.between(powerUp, self)
    }

    func collides(with cloud: Cloud) -> Event? {
        return ContactHandler.between(cloud, self)
    }

    func collides(with floor: Floor) -> Event? {
        return ContactHandler.between(floor, self)
    }

    func collides(with platform: Platform) -> Event? {
        return ContactHandler.between(platform, self)
    }

    func collides(with wall: Wall) -> Event? {
        return ContactHandler.between(self, wall)
    }

    func collides(with disaster: Disaster) -> Event? {
        return ContactHandler.between(self, disaster)
    }

    func collides(with guest: Guest) -> Event? {
        return ContactHandler.between(self, guest)
    }
}
