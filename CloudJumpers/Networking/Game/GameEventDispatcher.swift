//
//  GameEventDispatcher.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

protocol GameEventDispatcher {
    func dispatchGameEventCommand(_ command: GameEventCommand)
}
