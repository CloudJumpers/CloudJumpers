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
    func collides(with wall: Wall) -> Event?
    func collides(with disaster: Disaster) -> Event?
    func collides(with guest: Guest) -> Event? 
}
