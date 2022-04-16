//
//  AchievementDataDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

protocol AchievementDataDelegate: AnyObject {
    var achievement: Achievement? { get set }

    init(_ userId: NetworkID)
    func fetchAchievementData(_ key: String)
    func updateAchievementData(_ key: String, _ value: Any)
}
