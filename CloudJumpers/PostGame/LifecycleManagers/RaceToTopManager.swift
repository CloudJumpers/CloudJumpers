//
//  RaceToTopManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

class RaceToTopManager: PostGameManager {
    private let completionData: RaceToTopData
    private let lobbyId: NetworkID
    private let seed: Int
    private var requestHandler: PostGameRequestDelegate?

    var callback: PostGameCallback = nil

    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()

    private var endpoint: String {
        let parameters = "\(seed)/\(urlSafeGameMode(mode: .timeTrial))/\(lobbyId)"
        return baseUrl + parameters
    }

    init(_ completionData: RaceToTopData, _ seed: Int, _ lobbyId: NetworkID) {
        self.completionData = completionData
        self.lobbyId = lobbyId
        self.seed = seed
        self.requestHandler = RestDelegate()
        self.requestHandler?.postGameManager = self
    }

    func submitForRanking() {
        var data = [String: Any]()
        data["userId"] = completionData.playerId
        data["userDisplayName"] = completionData.playerName
        data["completionTime"] = completionData.completionTime

        requestHandler?.submitLocalData(endpoint, data)
    }

    func subscribeToRankings() {
        requestHandler?.startRankingsFetch(endpoint, handleRankingsResponse)
    }

    func unsubscribeFromRankings() {
        requestHandler?.stopRankingsFetch()
    }

    private func handleRankingsResponse(_ data: Data) {
        let decoder = JSONDecoder()

        guard let response = try? decoder.decode(TimeTrialResponses.self, from: data) else {
            return
        }

        rankings.removeAll()
        response.topFivePlayers.enumerated().forEach { index, item in
            var columns = [PostGameColumnKey: String]()

            let completionTimeString = String(format: "%.2f", item.completionTime)

            columns[PostGameColumnKey(order: 1, description: "Name")] = item.userDisplayName
            columns[PostGameColumnKey(order: 2, description: "Completion Time")] = completionTimeString

            let rankingRow = IndividualRanking(
                position: index + 1,
                characteristics: columns
            )
            rankings.append(rankingRow)
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }
}
