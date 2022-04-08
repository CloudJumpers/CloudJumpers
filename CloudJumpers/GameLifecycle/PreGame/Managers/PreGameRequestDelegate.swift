//
//  PreGameRequestDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

protocol PreGameRequestDelegate: AnyObject {
    var preGameManager: PreGameManager? { get set }

    /// fetchRankingsOnce fetches highscores
    /// data once from the provided endpoint.
    func fetchRankingsOnce(_ endpoint: String, _ callback: @escaping(Data) -> Void)
}
