//
//  LobbyCell.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit

class LobbyCell: UICollectionViewCell {
    @IBOutlet private var roomName: UILabel!
    @IBOutlet private var gameMode: UILabel!
    @IBOutlet private var occupancy: UILabel!

    func setRoomName(name: String) {
        roomName.text = name
    }

    func setSelectedGameMode(config: PreGameConfig) {
        gameMode.text = config.name
    }

    func setOccupancy(num: Int, config: PreGameConfig) {
        occupancy.text = "\(num) / \(config.maximumPlayers)"
    }
}
