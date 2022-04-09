//
//  PositionSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class PositionSystem : System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    
    func update(within time: CGFloat, in entityManager: EntityManager) {
        return
    }
    
    func changePosition(for id: EntityID, to position: CGPoint) {
        
    }
}
