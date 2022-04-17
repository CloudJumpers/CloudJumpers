//
//  TimeTrial.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct TimeTrial: GameMode {
    let name = GameModeConstants.timeTrials

    let minimumPlayers = 1
    let maximumPlayers = 1

    private(set) var seed = Int.random(in: (Int.zero ... Int.max))

    private var players = [PlayerInfo]()

    func getGameRules() -> GameRules {
        TimeTrialGameRules()
    }

    mutating func setSeed(_ seed: Int) {
        self.seed = seed
    }

    mutating func setPlayers(_ players: [PlayerInfo]) {
        self.players = players

        let shadowPlayer = PlayerInfo(playerId: GameConstants.shadowPlayerID, displayName: "Shadow Rank 1")
        self.players.append(shadowPlayer)
    }

    func getIdOrderedPlayers() -> [PlayerInfo] {
        players
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        let endpoint = generateCommonEndpointPath()
        return TimeTrialPreGameManager(endpoint, lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, completionData: LocalCompletionData) -> PostGameManager {
        guard let completionData = completionData as? TimeTrialData else {
            fatalError("Could not finish TimeTrial game")
        }

        let endpoint = generateEndpointPath(lobbyId)
        return TimeTrialPostGameManager(completionData, endpoint, lobbyId)
    }

    private func generateCommonEndpointPath() -> String {
        "\(seed)/\(urlSafeName)"
    }

    private func generateEndpointPath(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
