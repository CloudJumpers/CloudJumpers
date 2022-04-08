//
//  TimeTrialPreGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

class TimeTrialPreGameManager: PreGameManager {
    func fetchTopLobbyId() -> fetchTopLobbyCallback {
        <#code#>
    }

    private let lobbyId: NetworkID
    private let seed: Int
    private weak var requestHandler: PreGameRequestDelegate?

    private var endpoint: String {
        let parameters = "\(seed)/\(urlSafeGameMode(mode: .timeTrial))/\(lobbyId)"
        return baseUrl + parameters
    }

    init(_ lobbyId: NetworkID, _ seed: Int) {
        self.lobbyId = lobbyId
        self.seed = seed
    }

}
