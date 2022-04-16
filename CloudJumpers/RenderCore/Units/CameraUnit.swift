//
//  CameraUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

class CameraUnit: RenderUnit {
    unowned var target: Simulatable?
    private unowned var scene: Scene?

    required init(on target: Simulatable?) {
        self.target = target
    }

    convenience init(on target: Simulatable?, watching scene: Scene?) {
        self.init(on: target)
        self.scene = scene
    }

    func transform(_ entity: Entity, with node: Node) {
        syncCameraAnchor(entity, with: node)
        syncCameraStatic(entity, with: node)
    }

    private func syncCameraStatic(_ entity: Entity, with node: Node) {
        let hasCameraStaticTag = target?.hasComponent(ofType: CameraStaticTag.self, in: entity) ?? false
        let isStaticNode = scene?.isStaticNode(node) ?? false

        if hasCameraStaticTag && !isStaticNode {
            scene?.setStaticNode(node)
        } else if !hasCameraStaticTag && isStaticNode {
            scene?.setUnstaticNode(node)
        }
    }

    private func syncCameraAnchor(_ entity: Entity, with node: Node) {
        let hasCameraAnchorTag = target?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false
        let isAnchoredNode = scene?.isCameraBoundNode(node) ?? false

        if hasCameraAnchorTag && !isAnchoredNode {
            scene?.bindCamera(to: node)
        }
    }
}
