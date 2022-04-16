//
//  AchievementFactory.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class AchievementFactory {
    private static let availableAchievements: [Achievement.Type] = [
        LightFootedAchievement.self,
        PowerUserAchievement.self
    ]

    static func createAchievements(userId: NetworkID, onLoad: AchievementOnLoad) -> [Achievement] {
        availableAchievements.map { $0.init(userId, onLoad) }
    }
}
