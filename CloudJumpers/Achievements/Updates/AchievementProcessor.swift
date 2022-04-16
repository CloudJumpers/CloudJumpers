//
//  AchievementProcessor.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class AchievementProcessor {
    private var keyObservers: [String: [Achievement]] = [:]
    var updater: AchievementUpdateDelegate?

    func addAchievement(_ achievement: Achievement) {
        achievement.metricKeys.forEach { addKey($0, for: achievement) }
    }

    func removeAchievement(_ achievement: Achievement) {
        achievement.metricKeys.forEach { removeKey($0, for: achievement) }
    }

    func processMetrics(_ metrics: [String: Int]) {
        metrics.forEach { notifyForKey($0.key, $0.value) }
    }

    func setTarget(_ metricsProvider: MetricsProvider) {
        updater?.stopObservingMetrics()
        updater = PollingUpdateDelegate()
        updater?.manager = self
        updater?.observeMetrics(from: metricsProvider)
    }

    private func addKey(_ key: String, for achievement: Achievement) {
        keyObservers[key, default: [Achievement]()].append(achievement)
    }

    private func removeKey(_ key: String, for achievement: Achievement) {
        keyObservers[key] = keyObservers[key]?.filter { $0 !== achievement }
    }

    private func notifyForKey(_ key: String, _ value: Int) {
        keyObservers[key]?.forEach { $0.update(key, value) }
    }
}
