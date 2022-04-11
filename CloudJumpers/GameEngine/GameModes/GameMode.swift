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
    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager
    func createPostGameManager(_ lobbyId: NetworkID, metaData: GameMetaData) -> PostGameManager

    init()
}

extension GameMode {
    var urlSafeName: String {
        name.components(separatedBy: .whitespaces).joined()
    }

    func doesMatch(_ name: String) -> Bool {
        name == self.name
    }
}
