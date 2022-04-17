//
//  RenderUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

protocol RenderUnit {
    var target: Simulatable? { get set }

    init(on target: Simulatable?)
    func transform(_ entity: Entity, with node: Node)
    func createNode(for entity: Entity) -> Node?
}

extension RenderUnit {
    func transform(_ entity: Entity, with node: Node) { }
    func createNode(for entity: Entity) -> Node? { nil }
}
