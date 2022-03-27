//
//  CJNetworkEncoder.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

class CJNetworkEncoder {
    static func toJsonString<T: Encodable>(_ item: T) -> String {
        let encoder = JSONEncoder()

        do {
            guard let jsonString = String(data: try encoder.encode(item), encoding: .utf8) else {
                fatalError("Expected json string conversion of \(item) to succeed")
            }

            return jsonString
        } catch {
            fatalError("Expected encode of NetworkEntity \(item) to succeed")
        }
    }
}
