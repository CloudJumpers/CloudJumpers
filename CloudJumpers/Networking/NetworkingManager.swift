//
//  NetworkingManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation

protocol NetworkingManager {
    var sessionId: String? { get set }

    func sendMessage(json: CJNetworkData) -> Bool

    func receiveMessage(json: CJNetworkData)
}
