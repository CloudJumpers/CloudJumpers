//
//  PostGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

typealias PostGameCallback = (() -> Void)?

protocol PostGameManager: AnyObject {
    /*
     callback is fired everytime an update
     to the set of rankings is detected.
     */
    var callback: PostGameCallback { get set }

    /*
     submitLocalData allows a player who has
     completed the game to create or update
     their game data.
     */
    func submitLocalData()

    /*
     startRankingsFetch periodically polls for
     ranking data from the relevant remote
     endpoint. If the manager is already polling,
     has no effect.
     */
    func startRankingsFetch()

    /*
     stopRankingsFetch stops the periodical
     poll for up to date information. If a poll
     is not ongoing, has no effect.
     */
    func stopRankingsFetch()
}

extension PostGameManager {
    var baseUrl: String {
        var urlString = ""

        urlString += PostGameConstants.webProtocol
        urlString += PostGameConstants.ipAddress
        urlString += PostGameConstants.portNum
        urlString += PostGameConstants.commonPath

        return urlString
    }

    func postWithoutResponse(_ url: URL, _ jsonData: [String: Any]) {
        Task(priority: .userInitiated) {
            var request = URLRequest(url: url)
            request.httpMethod = PostGameConstants.postRequest
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: [])
                let (_, response) = try await URLSession.shared.data(for: request)
                let httpResponse = response as? HTTPURLResponse
                assert(httpResponse?.statusCode == PostGameConstants.httpOK)
            } catch {
                print("POST url=\(url.path) with json=\(jsonData) failed: \(error)")
            }
        }
    }

    func getResponse(_ url: URL, _ callback: ((Data) -> Void)?) {
        Task(priority: .medium) {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                if let resp = response as? HTTPURLResponse, resp.statusCode == PostGameConstants.httpOK {
                    callback?(data)
                } else {
                    throw PostGameHTTPError.unexpectedStatusCode
                }
            } catch {
                print("GET url=\(url.path) failed: \(error)")
            }
        }
    }
}
