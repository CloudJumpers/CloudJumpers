//
//  Utils.swift
//  CloudJumpersTests
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation

class TestUtils {
    static func randomLowerAlnumString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0 ..< length).map{ _ in letters.randomElement()! }).lowercased()
    }
}

