//
//  PowerUpCollector.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 17/4/22.
//

import Foundation

class PowerUserAchievement: Achievement {
    let title: String = "Power User"
    let description: String = "Use 100 power ups"
    let imageName: String = Images.bolt.rawValue
    let metricKeys: [String] = [String(describing: PowerUpActivateEvent.self)]

    private var powerUpsUsed: Int?
    private let required = 100

    var currentProgress: String {
        guard let used = powerUpsUsed else {
            return String(Double.zero)
        }
        return String(used)
    }

    var onLoad: AchievementOnLoad
    var dataUpdater: AchievementDataDelegate?

    var requiredProgress: String {
        String(required)
    }

    var progressRatio: Double {
        getProgressRatio(current: powerUpsUsed, required: required)
    }

    required init(_ userId: NetworkID, _ onLoad: AchievementOnLoad) {
        self.onLoad = onLoad
        self.dataUpdater = FBAchievementDataDelegate(userId)
        self.dataUpdater?.achievement = self

        fetchValuesOnce()
    }

    func load(_ key: String, _ value: Int) {
        assert(metricKeys.first == key)
        powerUpsUsed = value
        onLoad?()
    }

    func update(_ key: String, _ value: Int) {
        genericIncrement(key, value)
    }
}
