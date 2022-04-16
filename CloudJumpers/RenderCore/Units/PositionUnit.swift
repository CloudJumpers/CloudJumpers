//
//  SpriteUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

class PositionUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let positionComponent = target?.component(ofType: PositionComponent.self, of: entity) else {
            return
        }

        node.position = positionComponent.position
        node.xScale = abs(node.xScale) * positionComponent.side.rawValue
    }
}
