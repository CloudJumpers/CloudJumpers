//
//  Achievement.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/4/22.
//

import Foundation

protocol Achievement: AnyObject {
    var title: String { get }
    var description: String { get }
    var imageName: String { get }

    var currentProgress: String { get }
    var requiredProgress: String { get }
    var progressRatio: Double { get }
    var isUnlocked: Bool { get }

    var metricKeys: [String] { get }

    var onLoad: AchievementOnLoad { get }
    var dataUpdater: AchievementDataDelegate? { get }
    func load(_ key: String, _ value: Int)
    func update(_ key: String, _ value: Int)

    init(_ userId: NetworkID, _ onLoad: AchievementOnLoad)
}

extension Achievement {
    var isUnlocked: Bool {
        !progressRatio.isLess(than: 1.0)
    }

    func getTitledKey(_ key: String) -> String {
        "\(title) \(key)"
    }

    func getUntitledKey(_ specificKey: String) -> String {
        let parts = specificKey.components(separatedBy: "\(title) ")
        guard let key = parts.last else {
            fatalError("Expected key to exist")
        }
        return key
    }

    func fetchValuesOnce() {
        metricKeys.forEach { dataUpdater?.fetchAchievementData(getTitledKey($0)) }
    }

    func genericLoad(_ key: String, _ value: Int) {
        load(getUntitledKey(key), value)
    }

    func genericIncrement(_ key: String, _ value: Int) {
        dataUpdater?.incrementAchievementData(getTitledKey(key), by: value)
    }

    func getProgressRatio(current: Double?, required: Double) -> Double {
        guard let current = current else {
            return Double.zero
        }

        return min(1.0, current / required)
    }

    func getProgressRatio(current: Int?, required: Int) -> Double {
        guard let curr = current else {
            return Double.zero
        }

        return getProgressRatio(current: Double(curr), required: Double(required))
    }
}
