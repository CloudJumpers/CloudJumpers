//
//  GameEventEmulator.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 18/4/22.
//

import Foundation

protocol GameEventEmulator: GameEventSubscriber {
    var hasReplayStarted: Bool { get }

    func replayEventsFrom(_ channelId: NetworkID)
}
