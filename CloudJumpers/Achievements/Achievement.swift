//
//  Achievement.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/4/22.
//

import Foundation

protocol Achievement: AnyObject {
    var title: String { get }
    var description: String { get }

    var currentProgress: String? { get }
    var requiredProgress: String { get }
    var isUnlocked: Bool { get }

    var metricKeys: [String] { get }

    func update(_ key: String, _ value: Any)
}
