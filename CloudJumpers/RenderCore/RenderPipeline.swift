//
//  RenderPipeline.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

class RenderPipeline {
    private typealias UnitMap = [String: RenderUnit]

    private var units: UnitMap

    init() {
        units = UnitMap()
    }

    func render(_ entity: Entity, with node: Node) {
        units.values.forEach { $0.transform(entity, with: node) }
    }

    func unit<T: RenderUnit>(ofType type: T.Type) -> T? {
        let identifier = String(describing: type.self)
        return units[identifier] as? T
    }

    func register(_ unit: RenderUnit) {
        let identifier = String(describing: type(of: unit).self)
        units[identifier] = unit
    }
}
