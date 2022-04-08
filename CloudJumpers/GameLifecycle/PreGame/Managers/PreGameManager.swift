//
//  PreGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

typealias fetchTopLobbyCallback = () -> NetworkID

protocol PreGameManager: AnyObject {
    func fetchTopLobbyId() -> fetchTopLobbyCallback
}

extension PreGameManager {
    var baseUrl: String {
        var urlString = ""

        urlString += LifecycleConstants.webProtocol
        urlString += LifecycleConstants.ipAddress
        urlString += LifecycleConstants.portNum
        urlString += LifecycleConstants.commonPath

        return urlString
    }
}
