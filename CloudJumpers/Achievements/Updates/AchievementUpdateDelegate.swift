//
//  AchievementUpdateDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

protocol AchievementUpdateDelegate: AnyObject {
    var processor: AchievementProcessor? { get set }

    func observeMetrics(from provider: MetricsProvider)
}
