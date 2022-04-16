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
}

extension RenderUnit {
    func transform(_ entity: Entity, with node: Node) { }
}
