//
//  EndGameCell.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 20/3/22.
//

import Foundation
import UIKit

class EndGameCell: UITableViewCell {
    func setupEndGameCell() {
        layer.borderWidth = EndGameConstants.cellBorderWidth
        layer.cornerRadius = EndGameConstants.cellCornerRadius
        layer.borderColor = EndGameConstants.cellBorderColor
    }

    func displayText(text: String) {
        textLabel?.text = text
    }
}
