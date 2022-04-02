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
        nil
    }
}
