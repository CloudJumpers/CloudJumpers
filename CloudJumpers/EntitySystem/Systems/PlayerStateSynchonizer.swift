//
//  PlayerStateSynchonizer.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class PlayerStateSynchronizer : System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }
    
    func update(within time: CGFloat) {
        return
    }
    
    
}
