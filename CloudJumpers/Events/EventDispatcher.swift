//
//  EventDispatcher.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

protocol EventDispatcher: AnyObject {
    func dispatch(_ remoteEvent: RemoteEvent)
}
