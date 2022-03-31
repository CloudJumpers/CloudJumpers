//
//  PostGameConstants.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

enum PostGameConstants {
    static let pollInterval: Double = 2.0

    // server information
    static let webProtocol = "http://"
    static let ipAddress = "54.169.132.128"
    static let portNum = ":8080"
    static let commonPath = "/api/highscores/v1/"

    // request types
    static let postRequest = "POST"
    static let getRequest = "GET"

    // status codes
    static let httpOK = 200

    static let postGameAPIQueue = "CJPostGameAPICallQueue"
}

enum PostGameHTTPError: Error {
    case unexpectedStatusCode
}
