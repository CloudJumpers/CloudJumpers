//
//  KingOfTheHillPreGameManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

class KingOfTheHillPreGameManager: PreGameManager {
    let lobbyId: NetworkID

    init(_ lobbyId: NetworkID) {
        self.lobbyId = lobbyId
    }

    func getEventHandlers() -> RemoteEventHandlers {
        let publisher = FirebasePublisher(lobbyId)
        let subscriber = FirebaseSubscriber(lobbyId)
        return RemoteEventHandlers(publisher: publisher, subscriber: subscriber)
    }

}
