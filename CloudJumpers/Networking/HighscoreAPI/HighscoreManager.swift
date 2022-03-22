//
//  HighscoreManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

class HighscoreManager {
    func fetchTopFiveRecords(
        gameMode: GameMode,
        gameSeed: EntityID,
        callback: @escaping ([Highscore]) -> Void
    ) {
        let url = constructEndpointUrl(gameMode: gameMode, gameSeed: gameSeed)

        let call = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == HighscoreConstants.httpOk
            else {
                print("\(url): error = \(error.debugDescription) resp = \(response.debugDescription)")
                return
            }

            let decoder = JSONDecoder()

            if let data = data, let highscores = try? decoder.decode(HighscoreResponse.self, from: data) {
                callback(highscores.topFivePlayers)
            }
        }

        call.resume()
    }

    func submitToTimeTrialHighscores(
        userId: EntityID,
        userDisplayName: String,
        gameScore: String,
        gameSeed: String,
        callback: @escaping NetworkCallback
    ) {
        let url = constructEndpointUrl(gameMode: GameMode.TimeTrial, gameSeed: gameSeed)

        var jsonToSend = [String: Any]()
        jsonToSend["userId"] = userId
        jsonToSend["userDisplayName"] = userDisplayName
        jsonToSend["completionTime"] = gameScore

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonToSend, options: [])

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("POST request for highscores,"
                          + "json=\(jsonToSend) resp=\(response.debugDescription) err=\(error)")
                }
                callback()
            }
            task.resume()
        } catch {
            print("Error occurred with POST request: \(error)")
        }
    }

    private func constructEndpointUrl(gameMode: GameMode, gameSeed: EntityID) -> URL {
        let urlAsString = "\(HighscoreConstants.webProtocol)\(HighscoreConstants.ipAddress):"
        + "\(HighscoreConstants.portNum)/\(HighscoreConstants.path)"
        + "\(gameSeed)/\(urlSafeGameMode(mode: gameMode))"

        guard let url = URL(string: urlAsString) else {
            fatalError("Unable to convert \(urlAsString) to a URL object.")
        }

        return url
    }
}
