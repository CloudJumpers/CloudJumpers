//
//  Renderable.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

protocol Renderable {
    var renderingComponent: RenderingComponent { get }

    func activate(renderingSystem: RenderingSystem)
}
