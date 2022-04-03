//
//  ExternalRemoveEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import Foundation

struct ExternalRemoveEvent: RemoteEvent {
    var entityToRemoveId: String
    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return RemoveEventCommand(sourceId: sourceId, event: self)
    }
}
