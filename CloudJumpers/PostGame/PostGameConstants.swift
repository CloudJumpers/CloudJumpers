//
//  PostGameConstants.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

enum PostGameConstants {
    static let pollInterval: Double = 2.0

    // interface
    static let rankingCellIdentifier = "com.cs3217.cloudjumpers.rankingcell"
    static let dateTimeFormat = "HH:mm, d MMM y"

    // server information
    static let webProtocol = "http://"
    static let ipAddress = "54.169.132.128"
    static let portNum = ":8080"
    static let commonPath = "/api/highscores/v1/"
}
