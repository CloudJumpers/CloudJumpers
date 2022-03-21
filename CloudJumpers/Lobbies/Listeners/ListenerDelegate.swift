//
//  ListenerDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

protocol ListenerDelegate: AnyObject {
    var managedLobby: NetworkedLobby? { get set }
}
