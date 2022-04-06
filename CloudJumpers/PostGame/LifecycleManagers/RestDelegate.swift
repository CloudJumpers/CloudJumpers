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
class RestDelegate: PostGameRequestDelegate {
    weak var postGameManager: PostGameManager?

    private var pollTimer: Timer?

    func submitLocalData(_ endpoint: String, _ keyValData: [String: Any]) {
        let url = RestDelegate.stringToURL(endpoint)
        post(url, keyValData)
    }

    func startRankingsFetch(_ endpoint: String, _ callback: @escaping (Data) -> Void) {
        guard pollTimer == nil else {
            return
        }

        pollTimer = Timer.scheduledTimer(
            withTimeInterval: PostGameConstants.pollInterval,
            repeats: true
        ) { [weak self] _ in
            let url = RestDelegate.stringToURL(endpoint)
            self?.get(url, callback)
        }

        // Immediately fire off initial request
        pollTimer?.fire()
    }

    func stopRankingsFetch() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    private func post(_ url: URL, _ jsonData: [String: Any]) {
        RequestMaker.post(url, jsonData)
    }

    private func get(_ url: URL, _ callback: ((Data) -> Void)?) {
        RequestMaker.get(url, callback)
    }

    static func stringToURL(_ endpoint: String) -> URL {
        guard let url = URL(string: endpoint) else {
            fatalError("stringToURL failed for \(endpoint)")
        }
        return url
    }
}
