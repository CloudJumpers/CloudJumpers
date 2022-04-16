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

    var currentProgress: String? { get }
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
    func getSpecificKey(_ key: String) -> String {
        "\(title) \(key)"
    }

    func recoverGenericKey(_ specificKey: String) -> String {
        let parts = specificKey.components(separatedBy: "\(title) ")
        guard let key = parts.last else {
            fatalError("Expected key to exist")
        }
        return key
    }

    func fetchOnce(_ key: String) {
        dataUpdater?.fetchAchievementData(getSpecificKey(key))
    }

    func genericLoad(_ key: String, _ value: Int) {
        load(recoverGenericKey(key), value)
    }

    func genericIncrement(_ key: String, _ value: Int) {
        dataUpdater?.incrementAchievementData(getSpecificKey(key), by: value)
    }
}
