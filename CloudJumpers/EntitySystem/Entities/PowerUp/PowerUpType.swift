//
//  PowerUpType.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import Foundation

enum PowerUpType: String {
    case freeze
    case confuse

    var name: String {
        rawValue
    }
}
