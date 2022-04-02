//
//  DisasterStartEventCommand.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

struct DisasterStartEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: OnlineDisasterEvent) {
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

        guard let parameters = try? decoder.decode(OnlineDisasterEvent.self, from: jsonData),
              let disasterType = DisasterComponent.Kind(rawValue: parameters.disasterType)
        else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = DisasterStartEvent(
            position: CGPoint(x: parameters.disasterPositionX, y: parameters.disasterPositionY),
            at: parameters.timestamp,
            velocity: CGVector(dx: parameters.disasterVelocityX, dy: parameters.disasterVelocityY),
            disasterType: disasterType,
            playerId: source,
            isSharing: false,
            isExecutedLocally: true)
        eventManager.add(eventToProcess)
        return true
    }
}
