//
//  ExternalRespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/2/22.
//

import Foundation

struct ExternalRespawnEvent: RemoteEvent {
    var positionX: Double
    var positionY: Double
    var killedBy: EntityID

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return RespawnEventCommand(sourceId: sourceId, event: self)
    }
}
