//
//  GameState.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/18/22.
//

import Foundation

protocol GameState {
    var type: GameStateType { get set }
}

enum GameStateType {
    case playing
    case end
}
