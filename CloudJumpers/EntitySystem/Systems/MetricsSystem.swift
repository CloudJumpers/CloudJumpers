//
//  MetricsSystem.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation
import CoreGraphics

class MetricsSystem: System {
    var active = true

    private var counts: [String: Int]
    private var transientCounts: [String: Int]

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.transientCounts = [:]
        self.counts = [:]
    }

    func fetchDeltaMetrics() -> [String: Int] {
        let snapshot = transientCounts
        transientCounts.removeAll()
        return snapshot
    }

    func fetchPersistentMetrics() -> [String: Int] {
        counts
    }

    func incrementMetric(_ key: String) {
        counts[key, default: Int.zero] += 1
        transientCounts[key, default: Int.zero] += 1
    }

    func handleRespawn(_ killed: EntityID, _ killedBy: EntityID) {
        guard let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              playerEntity.id == killed || playerEntity.id == killedBy
        else { return }

        let identifier = playerEntity.id == killed ?
            String(describing: RespawnEvent.self) : String(describing: ExternalRespawnEvent.self)
        incrementMetric(identifier)
    }
}
