//
//  GameMode.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

import Foundation

enum GameMode: String {
    case TimeTrial = "Time Trial"
}

func urlSafeGameMode(mode: GameMode) -> String {
    mode.rawValue.components(separatedBy: .whitespaces).joined()
}
