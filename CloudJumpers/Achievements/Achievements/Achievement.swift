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

    var userId: NetworkID { get }
    var currentProgress: String? { get }
    var requiredProgress: String { get }
    var isUnlocked: Bool { get }

    var metricKeys: [String] { get }

    var dataDelegate: AchievementDataDelegate? { get }
    func load(_ key: String, _ value: Any)
    func update(_ key: String, _ value: Any)

    init(userId: NetworkID)
}

extension Achievement {
    func getSpecificKey(_ key: String) -> String {
        "\(title) \(key)"
    }

    func recoverGenericKey(_ specificKey: String) -> String {
        let parts = specificKey.components(separatedBy: "\(title) ")

        assert(parts.first == title)
        assert(parts.count == 2)

        guard let key = parts.last else {
            fatalError("Expected key to exist")
        }
        return key
    }

    func fetchOnce(_ key: String) {
        dataDelegate?.fetchAchievementData(getSpecificKey(key))
    }

    func genericLoad(_ key: String, _ value: Any) {
        load(recoverGenericKey(key), value)
    }

    func update(_ key: String, _ value: Any) {
        dataDelegate?.updateAchievementData(getSpecificKey(key), value)
    }
}
