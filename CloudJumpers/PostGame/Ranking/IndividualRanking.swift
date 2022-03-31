//
//  Ranking.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

struct IndividualRanking {
    /*
     Position is used to demonstrate relative rankings between
     players. It is not expected to be available (to facilitate
     non-competitive game modes) and is not expected to be unique,
     to facilitate ties.
     */
    let position: Int?

    /*
     Characteristics represent the gamemode dependent list of fields
     associated with this ranking entry. E.g. time taken, number of kills
     will all be stored as key value pairs within characteristics.
     */
    let characteristics: [String: String]

    let displayName: String
}
