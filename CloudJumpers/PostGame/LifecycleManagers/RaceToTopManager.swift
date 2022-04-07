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
        let parameters = "\(seed)/\(urlSafeGameMode(mode: .raceTop))/\(lobbyId)"
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
        data["kills"] = Int.zero // TODO: get from game
        data["deaths"] = Int.zero

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

        guard let response = try? decoder.decode(RaceToTopResponses.self, from: data) else {
            return
        }

        rankings.removeAll()
        response.topLobbyPlayers.enumerated().forEach { index, item in
            let completionTimeString = String(format: "%.2f", item.completionTime)

            var rankingRow = IndividualRanking()

            rankingRow.setPrimaryField(colName: "Position", value: index)
            rankingRow.setPrimaryField(colName: "Name", value: item.userDisplayName)
            rankingRow.setPrimaryField(colName: "Completion Time", value: completionTimeString)
            rankingRow.setPrimaryField(colName: "Kills", value: item.kills)
            rankingRow.setPrimaryField(colName: "Deaths", value: item.deaths)

            if completionData.playerId == item.userId {
                rankingRow.setSupportingField(colName: "isUserRow", value: true)
            }

            rankings.append(rankingRow)
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }
}
