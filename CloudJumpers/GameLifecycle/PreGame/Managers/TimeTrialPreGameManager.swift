//
//  TimeTrialPreGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

class TimeTrialPreGameManager: PreGameManager {
    private let lobbyId: NetworkID
    private let endpointKey: String

    private weak var requestHandler: PreGameRequestDelegate?

    private var endpoint: String {
        baseUrl + endpointKey
    }

    init(_ endpointKey: String, _ lobbyId: NetworkID) {
        self.endpointKey = endpointKey
        self.lobbyId = lobbyId
    }

    func getEventHandlers() -> RemoteEventHandlers {
        let publisher = FirebasePublisher(lobbyId)
        let subscriber = FirebaseEmulator()

        initializeSubscriberWithTopPlayer(subscriber)
        return RemoteEventHandlers(publisher: publisher, subscriber: subscriber)
    }

    private func initializeSubscriberWithTopPlayer(_ subscriber: FirebaseEmulator) {
        func handleResponse(_ data: Data) {
            let decoder = JSONDecoder()

            guard
                let response = try? decoder.decode(TimeTrialResponses.self, from: data),
                let first = response.topGlobalPlayers.first
            else {
                return
            }

            subscriber.initialize(first.lobbyId)
        }

        let url = RequestMaker.stringToURL(endpoint)
        RequestMaker.get(url, handleResponse)
    }
}
