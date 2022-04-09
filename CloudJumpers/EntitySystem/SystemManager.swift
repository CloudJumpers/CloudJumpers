//
//  SystemManager.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 8/4/22.
//

import Foundation

class SystemManager {
    private typealias SystemMap = [String: System]

    private var systems: SystemMap

    init() {
        systems = SystemMap()
        setUpSystems()
    }

    func update(within time: TimeInterval, in entityManager: EntityManager) {
        for system in systems.values where system.shouldUpdate(within: time, in: entityManager) {
            system.update(within: time, in: entityManager)
        }
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        let identifier = String(describing: type.self)
        return systems[identifier] as? T
    }

    private func register(_ system: System) {
        let identifier = String(describing: system.self)
        systems[identifier] = system
    }

    private func setUpSystems() {
        // TODO: Set up systems here
    }
}
