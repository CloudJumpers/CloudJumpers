//
//  Player+Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

extension Player: Collidable {
    func collides(with collidable: Collidable) -> Event? {
        collidable.collides(with: self)
    }

    func collides(with player: Player) -> Event? {
        ContactHandler.between(self, player)
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
        SeparationHandler.between(self, player)
    }

    func separates(from powerUp: PowerUp) -> Event? {
        SeparationHandler.between(self, powerUp)
    }

    func separates(from cloud: Cloud) -> Event? {
        SeparationHandler.between(self, cloud)
    }

    func separates(from floor: Floor) -> Event? {
        SeparationHandler.between(self, floor)
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
