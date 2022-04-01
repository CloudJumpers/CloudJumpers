//
//  TimeTrialData.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

struct TimeTrialData: LocalCompletionData {
    let playerId: NetworkID
    let playerName: String
    let completionTime: Double
}
