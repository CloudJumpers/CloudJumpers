//
//  EventualPublisher.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 6/4/22.
//

protocol EventualPublisher: GameEventPublisher {
    func forcePublishAll()
}
