//
//  EventManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Foundation

class EventManager {
    private var eventQueue = [Event]()

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
