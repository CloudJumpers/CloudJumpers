//
//  PostGameRequestDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

protocol PostGameRequestDelegate: AnyObject {
    var postGameManager: PostGameManager? { get set }

    /// Allows a player who has completed their game
    /// to create or update their game data.
    func submitLocalData(_ endpoint: String, _ keyValData: [String: Any])

    /// startRankingsFetch periodically polls for ranking data from
    /// the relevant remote endpoint. If the manager is already polling,
    /// has no effect.
    func startRankingsFetch(_ endpoint: String, _ callback: @escaping (Data) -> Void)

    /// Stops further fetching of rankings data.
    /// If a poll is not ongoing, has no effect.
    func stopRankingsFetch()
}
