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

    func setGameMode(mode: String) {
        gameMode.text = mode
    }

    func setOccupancy(num: Int) {
        occupancy.text = "\(num) / \(LobbyConstants.MaxSupportedPlayers)"
    }
}
