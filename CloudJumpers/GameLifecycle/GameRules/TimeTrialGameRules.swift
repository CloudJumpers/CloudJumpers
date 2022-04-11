//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {

    private unowned var target: RuleModifiable?
    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule(isPlayingWithShadow: Bool) {
        if isPlayingWithShadow {
            target?.deactivateSystem(ofType: DisasterSpawnSystem.self)
        }
        target?.deactivateSystem(ofType: PowerSpawnSystem.self)
    }

    func hasGameEnd() -> Bool {
        guard let target = target,
              let player = target.components(ofType: PlayerTag.self).first?.entity,
              let stoodOnEntityID = target.component(ofType: StandOnComponent.self, of: player)?.standOnEntityID
        else {
            return false
        }
        return target.hasComponent(ofType: TopPlatformTag.self, in: stoodOnEntityID)
    }

}
