//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
import CoreGraphics

protocol GameRules {
    var playerInfo: PlayerInfo? { get set }
    func setTarget(_ target: RuleModifiable)
    func setUpForRule()
    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo])
    func enableHostSystems()
    func update(within time: CGFloat)
    func hasGameEnd() -> Bool

    func fetchLocalCompletionData() -> LocalCompletionData
}

// MARK: - Helper functions
extension GameRules {

    func enablePowerUpFunction(target: RuleModifiable) {
        target.activateSystem(ofType: PowerUpSystem.self)
        target.activateSystem(ofType: FreezeSystem.self)
        target.activateSystem(ofType: ConfuseSystem.self)
        target.activateSystem(ofType: SlowmoSystem.self)
        target.activateSystem(ofType: TeleportSystem.self)
        target.activateSystem(ofType: EffectorDetachSystem.self)
    }

    func isPlayerRespawning(target: RuleModifiable) -> (Bool, killedBy: EntityID?) {
        guard let playerID = playerInfo?.playerId,
              let playerStandOnComponent = target.component(ofType: StandOnComponent.self, of: playerID)
        else {
            return (false, nil)
        }
        let allStandOnComponent = target.components(ofType: StandOnComponent.self)

        for component in allStandOnComponent where component.entity?.id != playerID {
            if component.standOnEntityID == playerStandOnComponent.standOnEntityID &&
                component.timestamp > playerStandOnComponent.timestamp {
                return (true, component.entity?.id)
            }
        }
        return (false, nil)
    }

    func setUpTimer(initialValue: Double, to target: RuleModifiable) -> StaticLabel {
        let timer = StaticLabel(
            at: Constants.timerPosition,
            size: Constants.timerSize,
            initialValue: String(initialValue))

        target.add(timer)
        target.addComponent(TimedComponent(time: initialValue), to: timer)

        return timer
    }

    func updateLabelWithValue(_ value: String, label: StaticLabel, target: RuleModifiable) {
        guard let labelComponent = target.component(ofType: LabelComponent.self, of: label) else {
            return
        }
        labelComponent.displayValue = value
    }
}
