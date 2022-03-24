//
//  GameKeys.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

enum GameKeys {
    static let root = "channels"

    // root/{channelId}/{child}/*
    // saving some bytes with the key names ...
    static let source = "s"
    static let recipients = "r"
    static let payload = "p"
    static let registeredAt = "u"
}
