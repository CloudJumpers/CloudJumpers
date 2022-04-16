//
//  PollingUpdateDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class PollingUpdateDelegate: AchievementUpdateDelegate {
    weak var manager: AchievementProcessor?
    weak var provider: MetricsProvider?
    private var timer: Timer?

    func observeMetrics(from provider: MetricsProvider) {
        guard timer == nil else {
            return
        }

        timer = Timer.scheduledTimer(
            withTimeInterval: AchievementConstants.maxUpdateInterval,
            repeats: true
        ) { [weak self] _ in self?.pollMetrics() }
    }

    func stopObservingMetrics() {
        timer?.invalidate()
        timer = nil
    }

    private func pollMetrics() {
        guard let provider = provider else {
            return
        }

        manager?.processMetrics(provider.getMetricsUpdate())
    }
}
