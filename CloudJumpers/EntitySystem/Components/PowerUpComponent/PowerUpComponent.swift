//
//  PowerUpComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 1/4/22.
//

class PowerUpComponent: Component {
    enum Kind: String, CaseIterable {
        case freeze
        case confuse
        case slowmo
        case teleport
        case blackout

        var name: String { rawValue }
    }

    let kind: Kind

    init(_ kind: Kind) {
        self.kind = kind
        super.init()
    }
}
