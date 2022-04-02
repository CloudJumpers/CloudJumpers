//
//  TimeTrialResponse.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

struct TimeTrialResponse: Response {
    let userId: NetworkID
    let userDisplayName: String
    let completionTime: Double
    let completedAt: Double
}

struct TimeTrialResponses: Decodable {
    let topGlobalPlayers: [TimeTrialResponse]
}
