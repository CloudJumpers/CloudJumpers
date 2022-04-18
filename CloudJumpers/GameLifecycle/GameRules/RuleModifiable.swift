//
//  RuleModifiable.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/12/22.
//

import Foundation

protocol RuleModifiable: AnyObject {
    func add(_ event: Event)
    func dispatch(_ remoteEvent: RemoteEvent)
    func add(_ entity: Entity)
    func addComponent(_ component: Component, to entity: Entity)
    func hasComponent<T: Component>(ofType type: T.Type, in entityWithID: EntityID) -> Bool
    func components<T: Component>(ofType type: T.Type) -> [T]
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T?
    func component<T: Component>(ofType type: T.Type, of entityWithID: EntityID) -> T?
    func activateSystem<T: System>(ofType type: T.Type)
    func deactivateSystem<T: System>(ofType type: T.Type)
}
