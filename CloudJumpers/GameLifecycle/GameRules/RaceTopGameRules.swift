//
//  RaceTopGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation

class RaceTopGameRules: GameRules {
    private unowned var target: RuleModifiable?
    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    var player: Entity? {
        target?.components(ofType: PlayerTag.self).first?.entity
    }

    func update() {
        guard let player = player else {
            return
        }
        if isPlayerRespawn() {
            target?.add(RespawnEvent(onEntityWith: player.id, newPosition: Constants.playerInitialPosition))
            target?.dispatch(ExternalRespawnEvent(
                positionX: Constants.playerInitialPosition.x,
                positionY: Constants.playerInitialPosition.y))
            target?.add(ChangeStandOnLocationEvent(on: player.id, standOnEntityID: nil))
        }

    }

    private func isPlayerRespawn() -> Bool {
        guard let player = player,
              let playerStandOnComponent = target?.component(ofType: StandOnComponent.self, of: player),
              let allStandOnComponent = target?.components(ofType: StandOnComponent.self)
        else {
            return false
        }

        for component in allStandOnComponent where component.entity?.id != player.id {
            if component.standOnEntityID == playerStandOnComponent.standOnEntityID &&
                component.timestamp > playerStandOnComponent.timestamp {
                return true
            }
        }
        return false
    }

    func hasGameEnd() -> Bool {
        guard let target = target,
              let player = player,
              let stoodOnEntityID = target.component(ofType: StandOnComponent.self, of: player)?.standOnEntityID
        else {
            return false
        }
        return target.hasComponent(ofType: TopPlatformTag.self, in: stoodOnEntityID)
    }

}
