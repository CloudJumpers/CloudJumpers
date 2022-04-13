//
//  PowerUpHandler.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/4/22.
//

import Foundation

struct PowerUpHandler {
    static func activate(_ powerUp: FreezePowerUp, on entity: Entity, watching watchingEntity: Entity) -> Event? {
        FreezeEvent(onEntityWith: entity.id, watchingEntityID: watchingEntity.id)
    }
    
    static func activate(_ powerUp: ConfusePowerUp, on entity: Entity, watching watchingEntity: Entity) -> Event? {
        ConfuseEvent(onEntityWith: entity.id, watchingEntityID: watchingEntity.id)
    }
}
