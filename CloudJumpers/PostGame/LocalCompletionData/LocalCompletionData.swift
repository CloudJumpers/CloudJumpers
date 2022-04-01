//
//  GameData.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

protocol LocalCompletionData: Codable {
    var playerId: NetworkID { get }
    var playerName: String { get }
}
