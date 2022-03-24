//
//  MovementEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

struct MovementEvent: OnlineEvent, Codable {
    var positionX: Double = 5.63
    var positionY: Double = 23.7
    var action: String?
}
