//
//  APICaller.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

class RequestMaker {
    static func post(_ url: URL, _ jsonData: [String: Any]) {
        Task(priority: .userInitiated) {
            var request = URLRequest(url: url)
            request.httpMethod = RESTConstants.postRequest
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: [])
                let (_, response) = try await URLSession.shared.data(for: request)
                let httpResponse = response as? HTTPURLResponse
                assert(httpResponse?.statusCode == RESTConstants.httpOK)
            } catch {
                print("POST url=\(url.path) with json=\(jsonData) failed: \(error)")
            }
        }
    }

    static func get(_ url: URL, _ callback: ((Data) -> Void)?) {
        Task(priority: .medium) {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                if let resp = response as? HTTPURLResponse, resp.statusCode == RESTConstants.httpOK {
                    callback?(data)
                } else {
                    throw HTTPError.unexpectedStatusCode
                }
            } catch {
                print("GET url=\(url.path) failed: \(error)")
            }
        }
    }
}
