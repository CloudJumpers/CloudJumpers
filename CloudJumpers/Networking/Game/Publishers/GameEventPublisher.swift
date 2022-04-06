//
//  GameEventPublisher.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

protocol GameEventPublisher {
    func publishGameEventCommand(_ command: GameEventCommand)
}
