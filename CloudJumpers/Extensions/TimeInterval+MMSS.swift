//
//  Double+Time.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/18/22.
//

import Foundation

extension TimeInterval {
    var minuteSeconds: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: self) ?? String(describing: self)
    }
}
