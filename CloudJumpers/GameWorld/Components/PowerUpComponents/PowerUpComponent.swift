//
//  PowerUpComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 1/4/22.
//

class PowerUpComponent: Component {
    let kind: Kind

    init(_ kind: Kind) {
        self.kind = kind
        super.init()
    }
}

extension PowerUpComponent {
    enum Kind: String, CaseIterable {
        case freeze
        case confuse
        case slowmo
        case teleport
        case blackout
        case knife

        var name: String { rawValue }

        static var randomly: Self? { Self.allCases.randomElement() }
    }
}
