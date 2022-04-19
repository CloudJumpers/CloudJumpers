//
//  SceneUpdateDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 14/4/22.
//

public protocol SceneUpdateDelegate: AnyObject {
    func scene(_ scene: Scene, didBeginContactBetween nodeA: Node, and nodeB: Node)
    func scene(_ scene: Scene, didEndContactBetween nodeA: Node, and nodeB: Node)
    func sceneDidFinishUpdate(_ scene: Scene)
    func node(of coreNode: NodeCore) -> Node?
}
