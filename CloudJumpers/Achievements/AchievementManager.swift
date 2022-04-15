//
//  AchievementManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class AchievementManager {
    private var keyObservers: [String: [Achievement]] = [:]
    private var updateCheckTimer: Timer?

    func addAchievement(_ achievement: Achievement) {
        achievement.metricKeys.forEach { addKey($0, for: achievement) }
    }

    func removeAchievement(_ achievement: Achievement) {
        achievement.metricKeys.forEach { removeKey($0, for: achievement) }
    }

    private func addKey(_ key: String, for achievement: Achievement) {
        keyObservers[key, default: [Achievement]()].append(achievement)
    }

    private func removeKey(_ key: String, for achievement: Achievement) {
        keyObservers[key] = keyObservers[key]?.filter { $0 !== achievement }
    }

    private func notifyForKey(_ key: String, _ value: Any) {
        keyObservers[key]?.forEach { $0.update(key, value) }
    }

    private func processMetrics(_ metrics: [String: Any]) {
        metrics.forEach { notifyForKey($0.key, $0.value) }
    }
}
