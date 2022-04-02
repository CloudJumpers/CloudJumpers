//
//  SharedEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/2/22.
//

import Foundation

protocol SharedEvent: Event {
    var isSharing: Bool { get set }
    var isExecutedLocally: Bool { get set }
    func getSharedCommand() -> GameEventCommand
}
