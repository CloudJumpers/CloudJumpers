//
//  NetworkedEntity.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation

protocol NetworkedEntity: Codable, IdentifiableByEntityID {
    var lastUpdatedAt: Double { get }
}

extension NetworkedEntity {
    var lastUpdatedAt: Double {
        NSDate().timeIntervalSince1970
    }

    func toJsonString() -> String {
        let encoder = JSONEncoder()

        do {
            guard let jsonString = String(data: try encoder.encode(self), encoding: .utf8) else {
                fatalError("Expected json string conversion of \(self) to succeed")
            }

            return jsonString
        } catch {
            fatalError("Expected encode of NetworkEntity \(self) to succeed")
        }
    }
}
