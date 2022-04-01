//
//  Double+Random.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 1/4/22.
//

extension Double {
    static func random(between start: Double, and end: Double) -> Double {
        .random(in: start...end)
    }
}
