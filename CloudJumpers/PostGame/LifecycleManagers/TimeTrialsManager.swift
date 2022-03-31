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
        let parameters = "\(completionData.seed)/\(completionData.gameMode)"

        guard let url = URL(string: baseUrl + parameters) else {
            fatalError("Malformed URL string")
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

        postWithoutResponse(endpoint, data)
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

            self?.getResponse(url, self?.handleRankingsResponse)
        }
    }

    func stopRankingsFetch() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    private func handleRankingsResponse(_ data: Data) {
    }
}
