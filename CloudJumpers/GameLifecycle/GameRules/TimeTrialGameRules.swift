//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {

    private unowned var target: RuleModifiable?
    private var timer: TimedLabel?

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule(isPlayingWithShadow: Bool) {
        if isPlayingWithShadow {
            target?.deactivateSystem(ofType: DisasterSpawnSystem.self)
        }
        target?.deactivateSystem(ofType: PowerSpawnSystem.self)

        // Set game specific entity
        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        target?.add(timer)
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

    func fetchLocalCompletionData() {
        guard let timer = timer,
              let timedComponent = target?.component(ofType: TimedComponent.self, of: timer)
        else { return }

        // TODO: Return time for completion
    }

}
