//
//  Double+Time.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/18/22.
//

import Foundation

extension Double {
    func convertToTimeString() -> String {
        let minute = Int(self / 60)
        let second = self - Double(minute) * 60.0
        let secondString = String(format: "%.1f", second)
        return "\(minute):\(secondString)"
    }
}
