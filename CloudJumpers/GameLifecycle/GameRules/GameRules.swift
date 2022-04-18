//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import UIKit

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
    func updateRespawnIfPlayerOnSameCloudRule(target: RuleModifiable) {

        let (isRespawning, killedBy) = isPlayerRespawningOnCloud(target: target)

        if isRespawning, let killedBy = killedBy {
            handlePlayerRespawn(target: target, killedBy: killedBy)
        }
    }

    func updateRespawnIfPlayerOnSamePlatformRule(target: RuleModifiable) {
        let (isRespawning, killedBy) = isPlayerRespawningOnTopPlatform(target: target)
        if isRespawning, let killedBy = killedBy {
            handlePlayerRespawn(target: target, killedBy: killedBy)
        }
    }

    func handlePlayerRespawn(target: RuleModifiable, killedBy id: EntityID) {
        guard let playerID = playerInfo?.playerId else {
            return
        }
        target.add(RespawnEvent(
            onEntityWith: playerID,
            killedBy: id,
            newPosition: Constants.playerInitialPosition))

        target.dispatch(ExternalRespawnEvent(
            positionX: Constants.playerInitialPosition.x,
            positionY: Constants.playerInitialPosition.y,
            killedBy: id))
        target.add(ChangeStandOnLocationEvent(on: playerID, standOnEntityID: nil))
    }

    func enablePowerUpFunction(target: RuleModifiable) {
        target.activateSystem(ofType: PowerUpSystem.self)
        target.activateSystem(ofType: FreezeSystem.self)
        target.activateSystem(ofType: ConfuseSystem.self)
        target.activateSystem(ofType: SlowmoSystem.self)
        target.activateSystem(ofType: TeleportSystem.self)
        target.activateSystem(ofType: BlackoutSystem.self)
        target.activateSystem(ofType: EffectorDetachSystem.self)
    }

    func setUpTimer(initialValue: Double, to target: RuleModifiable) -> StaticLabel {
        let timer = StaticLabel(
            at: Constants.timerPosition,
            typeface: .display,
            size: Constants.labelFontSize,
            text: String(initialValue),
            color: UIColor(from: Colors.timerText))

        target.add(timer)
        target.addComponent(TimedComponent(time: initialValue), to: timer)

        return timer
    }

    func updateCountUpTimer(target: RuleModifiable, timer: StaticLabel) {
        guard let timedComponent = target.component(ofType: TimedComponent.self, of: timer)
        else {
            return
        }
        let timeString = timedComponent.time.minuteSeconds
        updateLabelWithValue(timeString, label: timer, target: target)
    }

    func updateLabelWithValue(_ value: String, label: StaticLabel, target: RuleModifiable) {
        guard let labelComponent = target.component(ofType: LabelComponent.self, of: label) else {
            return
        }
        labelComponent.text = value
    }
}
// MARK: Boolean Helper Functions
extension GameRules {
    func isPlayerRespawningOnCloud(target: RuleModifiable) -> (Bool, killedBy: EntityID?) {
        guard let playerID = playerInfo?.playerId,
              let playerStandOnComponent = target.component(ofType: StandOnComponent.self, of: playerID),
              isStandOnComponentCloud(target: target, component: playerStandOnComponent)
        else {
            return (false, nil)
        }
        let allStandOnComponent = target.components(ofType: StandOnComponent.self)

        for component in allStandOnComponent
        where component.entity?.id != playerID {
            if isStandOnComponentCloud(target: target, component: component)
                && isPlayerFirstStandOnEntity(playerStandOnComponent: playerStandOnComponent,
                                              otherStandOnComponent: component) {
                return (true, component.entity?.id)
            }
        }
        return (false, nil)
    }

    func isPlayerRespawningOnTopPlatform(target: RuleModifiable) -> (Bool, killedBy: EntityID?) {
        guard let playerID = playerInfo?.playerId,
              let playerStandOnComponent = target.component(ofType: StandOnComponent.self, of: playerID),
              isStandOnComponentTopPlatform(target: target, component: playerStandOnComponent)
        else {
            return (false, nil)
        }
        let allStandOnComponent = target.components(ofType: StandOnComponent.self)

        for component in allStandOnComponent
        where component.entity?.id != playerID {
            if isStandOnComponentTopPlatform(target: target, component: component)
                && isPlayerFirstStandOnEntity(playerStandOnComponent: playerStandOnComponent,
                                              otherStandOnComponent: component) {
                return (true, component.entity?.id)
            }
        }
        return (false, nil)
    }

    func isPlayerFirstStandOnEntity(playerStandOnComponent: StandOnComponent,
                                    otherStandOnComponent: StandOnComponent) -> Bool {
        guard let playerStandOnEntityID = playerStandOnComponent.standOnEntityID,
              let otherStandOnEntityID = otherStandOnComponent.standOnEntityID else {
            return false
        }
        return playerStandOnEntityID == otherStandOnEntityID &&
        playerStandOnComponent.timestamp < otherStandOnComponent.timestamp
    }

    func isStandOnComponentTopPlatform(target: RuleModifiable, component: StandOnComponent) -> Bool {
        guard let standOnEntityID = component.standOnEntityID else {
            return false
        }
        return target.hasComponent(ofType: TopPlatformTag.self, in: standOnEntityID)
    }

    // If not top platform, then must be cloud, assumed there are only 2 types
    func isStandOnComponentCloud(target: RuleModifiable, component: StandOnComponent) -> Bool {
        guard let standOnEntityID = component.standOnEntityID else {
            return false
        }
        return !target.hasComponent(ofType: TopPlatformTag.self, in: standOnEntityID)
    }

    func isPlayerOnTopPlatform(target: RuleModifiable) -> Bool {
        guard let playerID = playerInfo?.playerId,
              let standOnComponent = target.component(ofType: StandOnComponent.self, of: playerID)
        else {
            return false
        }
        return isStandOnComponentTopPlatform(target: target, component: standOnComponent)
    }

}
