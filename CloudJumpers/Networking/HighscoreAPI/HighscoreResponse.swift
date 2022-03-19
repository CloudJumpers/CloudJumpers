//
//  HighscoreResponse.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

struct HighscoreResponse: Codable {
    let topFivePlayers: [Highscore]
}
