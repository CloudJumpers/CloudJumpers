//
//  SeedGenerator.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/4/22.
//

import Darwin

struct SeedGenerator: RandomNumberGenerator {
    init(seed: Int) {
        srand48(seed)
    }

    // swiftlint:disable legacy_random
    func next() -> UInt64 {
        withUnsafeBytes(of: drand48()) { $0.load(as: UInt64.self) }
    }
    // swiftlint:enable legacy_random
}
