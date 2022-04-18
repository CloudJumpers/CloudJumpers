//
//  ExternalKillEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation

struct ExternalKillEntityEvent: RemoteEvent {
    var killedEntityID: String
    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return KilledEntityEventCommand(sourceId: sourceId, event: self)
    }
}
