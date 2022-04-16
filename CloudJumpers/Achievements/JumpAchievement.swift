//
//  JumpAchievement.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class JumpAchievement: Achievement {
    let onLoad: AchievementOnLoad

    let title: String = "Jumps"
    let description: String = "Lifetime jumps made across games."
    let imageName: String = Images.jumpingSprite.name
    let metricKeys: [String] = [String(describing: JumpEvent.self)]

    var dataUpdater: AchievementDataDelegate?

    private var userJumps: Int?
    private let requiredJumps = 1_000

    var currentProgress: String? {
        if let jumps = userJumps {
            return String(jumps)
        }
        return nil
    }

    var requiredProgress: String { String(requiredJumps) }

    var progressRatio: Double {
        guard let jumps = userJumps else {
            return Double.zero
        }

        return min(1.0, Double(jumps) / Double(requiredJumps))
    }

    var isUnlocked: Bool {
        guard let jumps = userJumps else {
            return false
        }

        return jumps >= requiredJumps
    }

    required init(_ userId: NetworkID, _ onLoad: AchievementOnLoad) {
        self.onLoad = onLoad
        self.dataUpdater = FBAchievementDataDelegate(userId)
        self.dataUpdater?.achievement = self

        metricKeys.forEach { fetchOnce($0) }
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
