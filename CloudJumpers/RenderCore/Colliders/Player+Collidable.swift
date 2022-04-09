//
//  Player+Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Player: Collidable {
    func collides(with collidable: Collidable) {
        collidable.collides(with: self)
    }

    func collides(with player: Player) {
        ContactHandler.between(self, player)
    }

    func collides(with powerUp: PowerUp) {
        ContactHandler.between(self, powerUp)
    }

    func collides(with cloud: Cloud) {
        ContactHandler.between(self, cloud)
    }

    func collides(with floor: Floor) {
        ContactHandler.between(self, floor)
    }

    func collides(with platform: Platform) {
        ContactHandler.between(self, platform)
    }

    func collides(with wall: Wall) {
        ContactHandler.between(self, wall)
    }

    func collides(with disaster: Disaster) {
        ContactHandler.between(self, disaster)
    }

    func collides(with guest: Guest) {
        ContactHandler.between(self, guest)
    }
}
