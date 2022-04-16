//
//  AnimationUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

class AnimationUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let animationComponent = target?.component(ofType: AnimationComponent.self, of: entity),
              let animation = animationComponent.activeAnimation,
              let spriteNode = node as? SpriteNode,
              spriteNode.activeAnimationKey != animation.key
        else { return }

        spriteNode.animateLoop(with: animation.frames, interval: 0.1, key: animation.key)
    }
}
