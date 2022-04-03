//
//  OnlineDisasterEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

struct ExternalDisasterEvent: RemoteEvent {
    var disasterPositionX: Double
    var disasterPositionY: Double
    var disasterVelocityX: Double
    var disasterVelocityY: Double
    var disasterType: String
    var disasterId: String

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return DisasterStartEventCommand(sourceId: sourceId, event: self)
    }
}
