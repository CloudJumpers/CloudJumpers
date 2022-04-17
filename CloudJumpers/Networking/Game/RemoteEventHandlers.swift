//
//  RemoteEventHandlers.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

class RemoteEventHandlers {
    let publisher: GameEventPublisher
    let subscriber: GameEventSubscriber

    init(publisher: GameEventPublisher, subscriber: GameEventSubscriber) {
        self.publisher = publisher
        self.subscriber = subscriber
    }
}
