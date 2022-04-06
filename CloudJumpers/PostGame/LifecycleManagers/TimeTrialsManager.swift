//
//  TimeTrialsManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

class TimeTrialsManager: PostGameManager {
    private let completionData: TimeTrialData
    private let lobbyId: NetworkID
    private let seed: Int
    private var requestHandler: PostGameRequestDelegate?

    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()

    var callback: PostGameCallback = nil

    private var submitEndpoint: String {
        let parameters = "\(seed)/\(urlSafeGameMode(mode: .timeTrial))/\(lobbyId)"
        return baseUrl + parameters
    }

    private var fetchEndpoint: String {
        let parameters = "\(seed)/\(urlSafeGameMode(mode: .timeTrial))"
        return baseUrl + parameters
    }

    init(_ completionData: TimeTrialData, _ seed: Int, _ lobbyId: NetworkID) {
        self.completionData = completionData
        self.seed = seed
        self.lobbyId = lobbyId
        self.requestHandler = RestDelegate()
        requestHandler?.postGameManager = self
    }

    func submitForRanking() {
        var data = [String: Any]()
        data["userId"] = completionData.playerId
        data["userDisplayName"] = completionData.playerName
        data["completionTime"] = completionData.completionTime

        requestHandler?.submitLocalData(submitEndpoint, data)
    }

    func subscribeToRankings() {
        requestHandler?.startRankingsFetch(fetchEndpoint, handleRankingsResponse)
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
        response.topGlobalPlayers.enumerated().forEach { index, item in
            var columns = [PostGameColumnKey: String]()

            let completionTimeString = String(format: "%.2f", item.completionTime)
            let completedAt = Date(timeIntervalSince1970: item.completedAt)

            let formatter = DateFormatter()
            formatter.dateFormat = PostGameConstants.dateTimeFormat

            columns[PostGameColumnKey(order: 1, description: "Name")] = item.userDisplayName
            columns[PostGameColumnKey(order: 2, description: "Completion Time")] = completionTimeString
            columns[PostGameColumnKey(order: 3, description: "Completed At")] = formatter.string(from: completedAt)

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
