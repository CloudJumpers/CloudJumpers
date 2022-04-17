//
//  Platform+Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Platform: Collidable {
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
        ContactHandler.between(self, platform)
    }

    func collides(with disaster: Disaster) -> Event? {
        ContactHandler.between(self, disaster)
    }

    func collides(with guest: Guest) -> Event? {
        ContactHandler.between(self, guest)
    }

    func separates(from collidable: Collidable) -> Event? {
        collidable.separates(from: self)
    }

    func separates(from player: Player) -> Event? {
        SeparationHandler.between(player, self)
    }

    func separates(from powerUp: PowerUp) -> Event? {
        SeparationHandler.between(powerUp, self)
    }

    func separates(from cloud: Cloud) -> Event? {
        SeparationHandler.between(cloud, self)
    }

    func separates(from floor: Floor) -> Event? {
        SeparationHandler.between(floor, self)
    }

    func separates(from platform: Platform) -> Event? {
        SeparationHandler.between(self, platform)
    }

    func separates(from disaster: Disaster) -> Event? {
        SeparationHandler.between(self, disaster)
    }

    func separates(from guest: Guest) -> Event? {
        SeparationHandler.between(self, guest)
    }
}
