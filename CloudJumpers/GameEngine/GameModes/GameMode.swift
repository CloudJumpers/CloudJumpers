//
//  GameMode.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

protocol GameMode {
    var name: String { get }

    var minimumPlayers: Int { get }
    var maximumPlayers: Int { get }

    func getGameRules() -> GameRules
    func createPreGameManager() -> PreGameManager
    func createPostGameManager(metaData: GameMetaData) -> PostGameManager
}

extension GameMode {
    var urlSafeName: String {
        name.components(separatedBy: .whitespaces).joined()
    }
}
