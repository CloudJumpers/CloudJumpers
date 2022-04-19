//
//  ExternalObtainEntityEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation

struct ExternalObtainEntityEvent: RemoteEvent {
    var obtainedEntityID: String
    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return ObtainEntityCommand(sourceId: sourceId, event: self)
    }
}
