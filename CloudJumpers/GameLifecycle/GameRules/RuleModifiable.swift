//
//  RuleModifiable.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/12/22.
//

import Foundation

protocol RuleModifiable: AnyObject {
    func components<T: Component>(ofType type: T.Type) -> [T]
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T?
    func add(_ event: Event)
    func add(_ entity: Entity)
    func activateSystem<T: System>(ofType type: T.Type)
    func deactivateSystem<T: System>(ofType type: T.Type)

}
