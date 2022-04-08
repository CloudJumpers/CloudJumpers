//
//  RestDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

/// RestDelegate interacts with a REST API to facilitate
/// requesting for data for a PostGameManager to
/// consume.
class PostGameRestDelegate: PostGameRequestDelegate {
    var postGameManager: PostGameManager?

    private var pollTimer: Timer?

    func submitLocalData(_ endpoint: String, _ keyValData: [String: Any]) {
        let url = RequestMaker.stringToURL(endpoint)
        RequestMaker.post(url, keyValData)
    }

    func startRankingsFetch(_ endpoint: String, _ callback: @escaping (Data) -> Void) {
        guard pollTimer == nil else {
            return
        }

        pollTimer = Timer.scheduledTimer(
            withTimeInterval: LifecycleConstants.pollInterval,
            repeats: true
        ) { _ in
            let url = RequestMaker.stringToURL(endpoint)
            RequestMaker.get(url, callback)
        }

        // Immediately fire off initial request
        pollTimer?.fire()
    }

    func stopRankingsFetch() {
        pollTimer?.invalidate()
        pollTimer = nil
    }
}
