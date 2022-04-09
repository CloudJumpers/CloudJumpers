//
//  EventModifiable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 8/4/22.
//

protocol EventModifiable: AnyObject {
    func add(_ entity: Entity)
    func add(_ event: Event)
    func remove(_ entity: Entity)
    func entity(with entityID: EntityID) -> Entity?
    func system<T: System>(ofType type: T.Type) -> T?
}
