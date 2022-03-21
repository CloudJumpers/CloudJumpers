//
//  NetworkCallback.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

typealias NetworkCallback = () -> Void
typealias LobbyCallback = (GameLobby, LobbyState) -> Void
typealias StringKeyValCallback = ((String, String) -> Void)?
typealias UserCallback = ((LobbyUser) -> Void)?
