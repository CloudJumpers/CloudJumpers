//
//  EventManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Foundation

class EventManager: EventDelegate {
    private var gameEventListener: GameEventListener = FirebaseGameEventListener("AAAAA")
    private let gameEventDispatcher: GameEventDispatcher = FirebaseGameEventDispatcher("AAAAA")

    private var eventQueue = [Event]()

    init() {
        gameEventListener.eventManager = self

        let event = MovementEvent()
        gameEventDispatcher.dispatchGameEventCommand(MovementCommand(sourceId: "ABCDE", movementEvent: event))
    }

    func event(add event: Event) {
        eventQueue.append(event)
    }
    func getEvents() -> [Event] {
        eventQueue
    }

    func resetEventQueue() {
        eventQueue.removeAll()
    }
}
