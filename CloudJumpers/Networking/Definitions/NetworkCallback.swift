//
//  NetworkCallback.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

typealias NetworkCallback = () -> Void
typealias LobbyLifecycleCallback = (GameLobby, LobbyState) -> Void
typealias LobbyMetadataCallback = (String) -> Void
typealias UserCallback = ((LobbyUser) -> Void)?
