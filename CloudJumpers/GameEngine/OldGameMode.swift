//
//  GameMode.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

import Foundation

enum OldGameMode: String, CaseIterable {
    case timeTrial = "Time Trial"
    case raceTop = "Race Top"

    func getMaxPlayer() -> Int {
        switch self {
        case .timeTrial:
            return 1
        case .raceTop:
            return 4
        }
    }

    func getMinPlayer() -> Int {
        switch self {
        case .timeTrial:
            return 1
        case .raceTop:
            return 2
        }
    }
}
