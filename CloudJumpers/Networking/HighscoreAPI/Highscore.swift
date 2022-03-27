//
//  Highscore.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

struct Highscore: Codable {
    let userId: NetworkID
    let userDisplayName: String
    let completionTime: String
    let completedAt: String
}
