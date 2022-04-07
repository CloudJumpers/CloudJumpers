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
            let completionTimeString = String(format: "%.2f", item.completionTime)
            let completedAt = Date(timeIntervalSince1970: item.completedAt)

            let formatter = DateFormatter()
            formatter.dateFormat = PostGameConstants.dateTimeFormat

            var rankingRow = IndividualRanking()

            rankingRow.setPrimaryField(colName: "Position", value: index)
            rankingRow.setPrimaryField(colName: "Name", value: item.userDisplayName)
            rankingRow.setPrimaryField(colName: "Completion Time", value: completionTimeString)
            rankingRow.setPrimaryField(colName: "Completed At", value: formatter.string(from: completedAt))

            if item.lobbyId == lobbyId, completionData.playerId == item.userId {
                rankingRow.setSupportingField(colName: "isUserRow", value: true)
            }

            rankings.append(rankingRow)
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }
}
