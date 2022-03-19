//
//  LobbyUpdaterDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

protocol ListenerDelegate: AnyObject {
    var onUserAdd: UserCallback { get }
    var onUserChange: UserCallback { get }
    var onUserRemove: UserCallback { get }
    var onLobbyChange: StringKeyValCallback { get }
}
