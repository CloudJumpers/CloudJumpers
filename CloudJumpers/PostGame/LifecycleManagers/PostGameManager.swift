//
//  PostGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

typealias PostGameCallback = (() -> Void)?

protocol PostGameManager: AnyObject {
    /// The callback to be fired everytime an update
    /// to the set of rankings is detected.
    var callback: PostGameCallback { get set }

    var fieldNames: [String]? { get }

    /// Latest ranking data available to the manager.
    var rankings: [IndividualRanking] { get }

    /// Allows a player who has completed their game
    /// to create or update their game data.
    func submitForRanking()

    /// Listen to changes in rankings
    func subscribeToRankings()

    /// Stop listening to changes in rankings
    func unsubscribeFromRankings()
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

    var fieldNames: [String]? {
        rankings.first?.columnNames
    }
}
