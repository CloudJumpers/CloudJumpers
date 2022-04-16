//
//  MetricsProvider.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

protocol MetricsProvider {
    func getMetricsUpdate() -> [String: Any]
}
