//
//  EventDispatcher.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

protocol EventDispatcher: AnyObject {
    var subscriber: GameEventSubscriber? { get set }
    var publisher: GameEventPublisher? { get set }
}

extension EventDispatcher {
    func dispatch(_ remoteEvent: RemoteEvent) {
        guard let command = remoteEvent.createDispatchCommand() else {
            return
        }

        publisher?.publishGameEventCommand(command)
    }
}
