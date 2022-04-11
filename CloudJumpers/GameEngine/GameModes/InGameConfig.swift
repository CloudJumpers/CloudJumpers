//
//  InGameConfig.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

protocol InGameConfig {
    var name: String { get }

    func getGameRules() -> GameRules
}
