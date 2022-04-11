//
//  PostGameConfig.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

protocol PostGameConfig {
    var name: String { get }

    func createPostGameManager(_ lobbyId: NetworkID, metaData: GameMetaData) -> PostGameManager
}
