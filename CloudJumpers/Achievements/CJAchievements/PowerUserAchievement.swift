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

    var currentProgress: String? {
        if let powerUpsUsed = powerUpsUsed {
            return String(powerUpsUsed)
        }
        return nil
    }

    var requiredProgress: String {
        String(required)
    }

    var progressRatio: Double {
        guard let used = powerUpsUsed else {
            return Double.zero
        }
        return min(1.0, Double(used) / Double(required))
    }

    var onLoad: AchievementOnLoad
    var dataUpdater: AchievementDataDelegate?

    func load(_ key: String, _ value: Int) {
        assert(metricKeys.first == key)
        powerUpsUsed = value
        onLoad?()
    }

    func update(_ key: String, _ value: Int) {
        genericIncrement(key, value)
    }

    required init(_ userId: NetworkID, _ onLoad: AchievementOnLoad) {
        self.onLoad = onLoad
        self.dataUpdater = FBAchievementDataDelegate(userId)
        self.dataUpdater?.achievement = self

        metricKeys.forEach { fetchOnce($0) }
    }
}
