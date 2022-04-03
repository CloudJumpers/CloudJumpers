//
//  LobbyUserCell.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 19/3/22.
//

import UIKit

class LobbyUserCell: UITableViewCell {
    @IBOutlet private var background: UIView!
    @IBOutlet private var isHostLabel: UILabel!
    @IBOutlet private var displayName: UILabel!

    func setIsReady(isReady: Bool) {
        background.backgroundColor = isReady ? .systemGreen : .white
    }

    func setIsHostLabelVisible(isVisible: Bool) {
        isHostLabel.isHidden = !isVisible
    }

    func setDisplayName(newDisplayName: String) {
        displayName.text = newDisplayName
    }
}
