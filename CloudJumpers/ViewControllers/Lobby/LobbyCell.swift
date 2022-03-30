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

    var mode: GameMode?

    func setRoomName(name: String) {
        roomName.text = name
    }

    func setGameMode(mode: GameMode) {
        self.mode = mode
        gameMode.text = mode.rawValue
    }

    func setOccupancy(num: Int) {
        occupancy.text = "\(num) / \(mode?.getMaxPlayer() ?? 1)"
    }
}
