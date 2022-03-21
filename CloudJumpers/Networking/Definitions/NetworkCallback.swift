//
//  NetworkCallback.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import Foundation

typealias NetworkCallback = () -> Void
typealias LobbyDataAvailableCallback = () -> Void
typealias LobbyLifecycleCallback = (LobbyState) -> Void
typealias LobbyMetadataCallback = (String) -> Void
