//
//  TimeTrialsManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

class TimeTrialPostGameManager: PostGameManager {
    private let completionData: TimeTrialData
    private let lobbyId: NetworkID
    private let endpointKey: String

    private var requestHandler: PostGameRequestDelegate?
    var callback: PostGameCallback = nil

    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()

    private var endpoint: String {
        baseUrl + endpointKey
    }

    init(_ completionData: TimeTrialData, _ endpointKey: String, _ lobbyId: NetworkID) {
        self.completionData = completionData
        self.endpointKey = endpointKey
        self.lobbyId = lobbyId
        self.requestHandler = PostGameRestDelegate()
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
        response.topGlobalPlayers.forEach { item in
            let completionTimeString = String(format: "%.2f", item.completionTime)
            let completedAt = Date(timeIntervalSince1970: item.completedAt)

            let formatter = DateFormatter()
            formatter.dateFormat = LifecycleConstants.dateTimeFormat

            var rankingRow = IndividualRanking()

            rankingRow.setPrimaryField(colName: "Position", value: item.position)
            rankingRow.setPrimaryField(colName: "Name", value: item.userDisplayName)
            rankingRow.setPrimaryField(colName: "Completion Time", value: completionTimeString)
            rankingRow.setPrimaryField(colName: "Completed At", value: formatter.string(from: completedAt))

            if item.lobbyId == lobbyId, completionData.playerId == item.userId {
                rankingRow.setSupportingField(colName: PGKeys.isUserRow, value: true)
            }

            rankings.append(rankingRow)
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }
}
