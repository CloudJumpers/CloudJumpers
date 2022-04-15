//
//  AchievementFactory.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class AchievementFactory {
    private static let availableAchievements: [Achievement.Type] = [
        JumpAchievement.self
    ]

    static func createAchievements(userId: NetworkID) -> [Achievement] {
        availableAchievements.map { $0.init(userId: userId) }
    }
}
