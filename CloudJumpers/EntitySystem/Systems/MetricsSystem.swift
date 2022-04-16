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

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager) {
        self.manager = manager
        self.counts = [:]
    }

    func update(within time: CGFloat) {
    }

    func fetchMetrics() -> [String: Int] {
        let snapshot = counts
        counts.removeAll()
        return snapshot
    }

    func incrementMetric(_ key: String) {
        counts[key, default: Int.zero] += 1
    }
}
