//
//  PreGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

protocol PreGameManager: AnyObject {
    func getEventHandlers() -> RemoteEventHandlers
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
