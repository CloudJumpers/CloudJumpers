//
//  KingOfTheHill.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 17/4/22.
//

import Foundation

struct KingOfTheHill: GameMode {
    let name = GameModeConstants.kingOfTheHill

    let minimumPlayers = 2
    let maximumPlayers = 4

    private(set) var seed = Int.random(in: (Int.min ... Int.max))

    private var players = [PlayerInfo]()

    func getGameRules() -> GameRules {
        KingHillGameRules()
    }

    mutating func setSeed(_ seed: Int) {
        self.seed = seed
    }

    mutating func setPlayers(_ players: [PlayerInfo]) {
        self.players = players
    }

    func getIdOrderedPlayers() -> [PlayerInfo] {
        players
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        KingOfTheHillPreGameManager(lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, completionData: LocalCompletionData) -> PostGameManager {
        guard let completionData = completionData as? KingOfTheHillData else {
            fatalError("Could not finish king of the hill game")
        }

        let endpoint = generateEndpoint(lobbyId)
        return KingOfTheHillPostGameManager(completionData, endpoint)
    }

    private func generateEndpoint(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
