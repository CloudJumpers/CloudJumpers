//
//  RespawnEffectEventCommand.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/2/22.
//

import Foundation
import CoreGraphics

struct RespawnEffectEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: OnlineRespawnEvent) {
        self.source = sourceId
        self.isSourceRecipient = false
        self.payload = CJNetworkEncoder.toJsonString(event)
    }

    init(_ source: NetworkID, _ payload: String) {
        self.source = source
        self.payload = payload
    }

    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(OnlineRespawnEvent.self, from: jsonData) else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = RespawnEffectEvent(onEntityWith: source,
                                                at: parameters.timestamp,
                                                at: CGPoint(x: parameters.positionX, y: parameters.positionY))

        eventManager.add(eventToProcess)
        return true
    }
}
