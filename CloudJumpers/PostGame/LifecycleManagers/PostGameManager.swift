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
     rankings is the latest ranking data
     available to the manager.
     */
    var rankings: [IndividualRanking] { get }

    /*
     rankingsTable returns a 2D table representation of rankings.
     If data rows are present, the first row will be the header.
     */
    var rankingsTable: [[String]] { get }

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

    var rankingsTable: [[String]] {
        guard let firstRow = rankings.first else {
            return [[String]]()
        }

        return [firstRow.columnNames] + rankings.map { $0.values }
    }

    // TODO: move http calls into Networking, and reuse here
    func post(_ url: URL, _ jsonData: [String: Any]) {
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

    func get(_ url: URL, _ callback: ((Data) -> Void)?) {
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
