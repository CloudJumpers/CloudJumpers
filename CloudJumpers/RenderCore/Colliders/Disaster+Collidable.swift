//
//  Disaster.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Disaster: Collidable {
    func collides(with collidable: Collidable) {
        collidable.collides(with: self)
    }

    func collides(with player: Player) {
        ContactHandler.between(player, self)
    }

    func collides(with powerUp: PowerUp) {
        ContactHandler.between(powerUp, self)
    }

    func collides(with cloud: Cloud) {
        ContactHandler.between(cloud, self)
    }

    func collides(with floor: Floor) {
        ContactHandler.between(floor, self)
    }

    func collides(with platform: Platform) {
        ContactHandler.between(platform, self)
    }

    func collides(with wall: Wall) {
        ContactHandler.between(wall, self)
    }

    func collides(with disaster: Disaster) {
        ContactHandler.between(self, disaster)
    }

    func collides(with guest: Guest) {
        ContactHandler.between(self, guest)
    }
}
