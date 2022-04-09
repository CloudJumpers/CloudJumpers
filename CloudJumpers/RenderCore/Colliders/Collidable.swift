//
//  Collidable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

protocol Collidable {
    func collides(with collidable: Collidable)
    func collides(with player: Player)
    func collides(with powerUp: PowerUp)
    func collides(with cloud: Cloud)
    func collides(with floor: Floor)
    func collides(with platform: Platform)
    func collides(with wall: Wall)
    func collides(with disaster: Disaster)
    func collides(with guest: Guest)
}
