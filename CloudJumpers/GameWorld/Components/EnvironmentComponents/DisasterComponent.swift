//
//  DisasterComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 1/4/22.
//

class DisasterComponent: Component {
    let kind: Kind

    init(_ kind: Kind) {
        self.kind = kind
        super.init()
    }
}

extension DisasterComponent {
    enum Kind: String, CaseIterable, Codable {
        case meteor

        var name: String { rawValue }

        static var randomly: Self? { Self.allCases.randomElement() }
    }
}
