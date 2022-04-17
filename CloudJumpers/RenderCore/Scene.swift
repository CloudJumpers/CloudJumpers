//
//  Scene.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 12/4/22.
//

import CoreGraphics

protocol Scene: AnyObject {
    var updateDelegate: SceneUpdateDelegate? { get set }
    var nodes: [Node] { get }
    var size: CGSize { get }
    var scrollable: Bool { get set }

    func contains(_ node: Node) -> Bool
    func addChild(_ node: Node, static: Bool)
    func removeChild(_ node: Node)

    func isCameraBoundNode(_ node: Node) -> Bool
    func bindCamera(to node: Node)

    func isStaticNode(_ node: Node) -> Bool
    func setStaticNode(_ node: Node)
    func setUnstaticNode(_ node: Node)
}
