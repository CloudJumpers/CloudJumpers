//
//  InGameConfig.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

protocol InGameConfig {
    var name: String { get }

    var seed: Int { get }

    func getGameRules() -> GameRules
    func getIdOrderedPlayers() -> [PlayerInfo]
}

extension InGameConfig {
    func getAchievementProcessor() -> AchievementProcessor {
        guard let userId = AuthService().getUserId() else {
            fatalError("UserId not retrievable in game")
        }

        let processor = AchievementProcessor()

        AchievementFactory.createAchievements(
            userId: userId,
            onLoad: nil
        ).forEach { processor.addAchievement($0) }

        return processor
    }
}
