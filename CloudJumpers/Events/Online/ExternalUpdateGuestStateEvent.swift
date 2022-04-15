//
//  ExternalRepositionEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation

struct ExternalUpdateGuestStateEvent: RemoteEvent {
    var positionX: Double
    var positionY: Double
    var texture: String

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return UpdateGuestStateEventCommand(sourceId: sourceId, event: self)
    }
}
