//
//  RenderEntity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation
class RenderEntity: Entity {
    var id = UUID()
}

extension RenderEntity: Hashable {
    static func == (lhs: RenderEntity, rhs: RenderEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
