//
//  AnimateSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class AnimateSystem : System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }
    
    func update(within time: CGFloat) {
        return
    }
    
    func changeAnimation(for id: EntityID,  to kind: TextureFrame) {
        guard let animationComponent = manager?.component(ofType: AnimationComponent.self, of: id) else {
            return
        }
        animationComponent.textures = [kind]
    }
    
    
}
