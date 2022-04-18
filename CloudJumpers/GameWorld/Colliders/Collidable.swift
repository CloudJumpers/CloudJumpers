//
//  Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

protocol Collidable {
    func collides(with collidable: Collidable) -> Event?
    func collides(with player: Player) -> Event?
    func collides(with powerUp: PowerUp) -> Event?
    func collides(with cloud: Cloud) -> Event?
    func collides(with floor: Floor) -> Event?
    func collides(with platform: Platform) -> Event?
    func collides(with disaster: Disaster) -> Event?
    func collides(with guest: Guest) -> Event?

    func separates(from collidable: Collidable) -> Event?
    func separates(from player: Player) -> Event?
    func separates(from powerUp: PowerUp) -> Event?
    func separates(from cloud: Cloud) -> Event?
    func separates(from floor: Floor) -> Event?
    func separates(from platform: Platform) -> Event?
    func separates(from disaster: Disaster) -> Event?
    func separates(from guest: Guest) -> Event?
}
