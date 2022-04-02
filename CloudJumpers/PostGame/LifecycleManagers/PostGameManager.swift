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

    /// Latest ranking data available to the manager.
    var rankings: [IndividualRanking] { get }

    /// A 2D table representation of rankings.
    /// If data rows are present, the first row will be the header.
    var rankingsTable: [[String]] { get }

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

    var rankingsTable: [[String]] {
        guard let firstRow = rankings.first else {
            return [[String]]()
        }

        return [firstRow.columnNames] + rankings.map { $0.values }
    }
}
