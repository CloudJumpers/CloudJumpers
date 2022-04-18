//
//  LabelUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/4/22.
//

class LabelUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func createNode(for entity: Entity) -> Node? {
        guard let labelComponent = target?.component(ofType: LabelComponent.self, of: entity),
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return nil }

        let node = LabelNode(text: labelComponent.text)
        node.position = positionComponent.position
        node.name = entity.id

        node.fontSize = labelComponent.fontSize
        node.zPosition = labelComponent.zPosition
        // TODO: Should put UIColor into Component?
        node.fontColor = .black

        Self.configureLabelNode(node, with: labelComponent)
        return node
    }

    private static func configureLabelNode(_ node: LabelNode, with labelComponent: LabelComponent) {
        node.alpha = labelComponent.alpha
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let labelComponent = target?.component(ofType: LabelComponent.self, of: entity),
              let labelNode = node as? LabelNode
        else {
            return
        }
        labelNode.alpha = labelComponent.alpha
        labelNode.text = labelComponent.text
    }

}
