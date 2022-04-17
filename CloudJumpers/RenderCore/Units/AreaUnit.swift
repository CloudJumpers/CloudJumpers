//
//  AreaUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/4/22.
//

class AreaUnit: RenderUnit {
    unowned var target: Simulatable?
    private unowned var scene: Scene?

    required init(on target: Simulatable?) {
        self.target = target
    }

    convenience init(on target: Simulatable?, representing scene: Scene?) {
        self.init(on: target)
        self.scene = scene
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let areaComponent = target?.component(ofType: AreaComponent.self, of: entity) else {
            return
        }

        scene?.scrollable = areaComponent.scrollable
        scene?.isBlank = areaComponent.isBlank
    }
}
