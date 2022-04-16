//
//  RaceToTop.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct RaceToTop: GameMode {
    let name = GameModeConstants.raceToTop

    var minimumPlayers: Int = 2
    var maximumPlayers: Int = 4

    private(set) var seed: Int = 161_001 // Int.random(in: (Int.min ... Int.max))

    private var players = [PlayerInfo]()

    func getGameRules() -> GameRules {
        RaceTopGameRules()
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
        RaceToTopPreGameManager(lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, completionData: LocalCompletionData) -> PostGameManager {

        guard let completionData = completionData as? RaceToTopData else {
            fatalError("Can not finish Race to the Top game")
        }
        let endpoint = generateEndpoint(lobbyId)
        return RaceToTopPostGameManager(completionData, endpoint)
    }

    private func generateEndpoint(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
