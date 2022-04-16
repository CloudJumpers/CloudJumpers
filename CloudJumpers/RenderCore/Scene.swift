//
//  Scene.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 12/4/22.
//

protocol Scene: AnyObject {
    var updateDelegate: SceneUpdateDelegate? { get set }
    var nodes: [Node] { get }

    func addChild(_ node: Node, static: Bool)
    func removeChild(_ node: Node)
    func bindCamera(to node: Node)
}
