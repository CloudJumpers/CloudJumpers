//
//  JumpAchievement.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class LightFootedAchievement: Achievement {
    let title: String = "Light-footed"
    let description: String = "1000 total jumps made in any game mode."
    let imageName: String = Images.jumpingSprite.name
    let metricKeys: [String] = [String(describing: JumpEvent.self)]

    let onLoad: AchievementOnLoad
    var dataUpdater: AchievementDataDelegate?

    private var userJumps: Int?
    private let requiredJumps = 1_000

    var currentProgress: String {
        guard let jumps = userJumps else {
            return String(Int.zero)
        }
        return String(jumps)
    }

    var requiredProgress: String { String(requiredJumps) }

    var progressRatio: Double {
        getProgressRatio(current: userJumps, required: requiredJumps)
    }

    required init(_ userId: NetworkID, _ onLoad: AchievementOnLoad) {
        self.onLoad = onLoad
        self.dataUpdater = FBAchievementDataDelegate(userId)
        self.dataUpdater?.achievement = self

        fetchValuesOnce()
    }

    func load(_ key: String, _ value: Int) {
        assert(metricKeys.first == key)
        userJumps = value
        onLoad?()
    }

    func update(_ key: String, _ value: Int) {
        genericIncrement(key, value)
    }
}
