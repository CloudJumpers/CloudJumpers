//
//  GameMode.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

protocol GameMode: PreGameConfig & InGameConfig & PostGameConfig {
    init()
}

extension GameMode {
    func doesMatch(_ name: String) -> Bool {
        name == self.name
    }

    var urlSafeName: String {
        name.components(separatedBy: .whitespaces).joined()
    }
}
