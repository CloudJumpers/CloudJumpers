//
//  Simulatable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 8/4/22.
//

protocol Simulatable: AnyObject {
    func entitiesToRender() -> [Entity]
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T?
    func hasComponent<T: Component>(ofType type: T.Type, in entity: Entity) -> Bool
    func handleContact(between entityAID: EntityID, and entityBID: EntityID)
    func syncPositions(with entityPositionMap: EntityPositionMap)
}
