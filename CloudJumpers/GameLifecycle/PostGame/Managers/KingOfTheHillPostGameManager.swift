//
//  KingOfTheHillPostGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

class KingOfTheHillPostGameManager: PostGameManager {
    private let completionData: KingOfTheHillData
    private let endpointKey: String

    private var requestHandler: PostGameRequestDelegate?
    var callback: PostGameCallback = nil

    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()

    private var endpoint: String {
        baseUrl + endpointKey
    }

    init(_ completionData: KingOfTheHillData, _ endpointKey: String) {
        self.completionData = completionData
        self.endpointKey = endpointKey
        self.requestHandler = PostGameRestDelegate()
        self.requestHandler?.postGameManager = self
    }

    func submitForRanking() {
        // TODO: setup backend services
    }

    func subscribeToRankings() {
        // ...
    }

    func unsubscribeFromRankings() {
        // ...
    }

}
