//
//  ExternalMoveEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 26/3/22.
//

import Foundation

struct ExternalMoveEvent: RemoteEvent {
    var displacementX: Double
    var displacementY: Double

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return MoveEventCommand(sourceId: sourceId, event: self)
    }
}
