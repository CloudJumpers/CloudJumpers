//
//  AchievementConstants.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

typealias AchievementOnLoad = (() -> Void)?

enum AchievementConstants {
    static let maxUpdateInterval: Double = 1.0

    static let cellReuseIdentifier = "com.cs3217.cloudjumpers.achievementcell"
}
