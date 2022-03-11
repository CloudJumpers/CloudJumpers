//
//  NetworkDataNormalizer.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation

typealias Json = [String: Any]

typealias CJNetworkData = String

/// This class is a layer where we can add functionality,
/// such as
/// - compression / decompression
/// - adding more attributes, such as timestamps
class NetworkDataProcessor {
    static func prepareOutgoingData(entity: NetworkedEntity) -> CJNetworkData {
        entity.toJsonString()
    }

    static func parseIncomingData(receivedData: CJNetworkData) {
        print("receivedData = \(receivedData)")
    }
}
