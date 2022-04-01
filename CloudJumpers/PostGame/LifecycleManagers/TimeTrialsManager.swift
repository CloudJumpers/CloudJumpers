//
//  TimeTrialsManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

class TimeTrialsManager: PostGameManager {
    private let completionData: TimeTrialData
    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()
    private var pollTimer: Timer?
    var callback: PostGameCallback = nil

    private var endpoint: URL {
        let parameters = "\(completionData.seed)/\(completionData.gameModeIdentifier)"

        guard let url = URL(string: baseUrl + parameters) else {
            fatalError("Malformed URL string \(baseUrl + parameters)")
        }

        return url
    }

    init(_ completionData: TimeTrialData) {
        self.completionData = completionData
    }

    func submitLocalData() {
        var data = [String: Any]()
        data["userId"] = completionData.playerId
        data["userDisplayName"] = completionData.playerName
        data["completionTime"] = completionData.completionTime

        post(endpoint, data)
    }

    func startRankingsFetch() {
        guard pollTimer == nil else {
            return
        }

        pollTimer = Timer.scheduledTimer(
            withTimeInterval: PostGameConstants.pollInterval,
            repeats: true
        ) { [weak self] _ in
            guard let url = self?.endpoint else {
                return
            }

            self?.get(url, self?.handleRankingsResponse)
        }

        // Immediately fire off initial request
        pollTimer?.fire()
    }

    func stopRankingsFetch() {
        pollTimer?.invalidate()
        pollTimer = nil
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
