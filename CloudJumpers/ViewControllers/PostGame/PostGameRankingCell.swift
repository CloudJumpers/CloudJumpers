//
//  PostGameRankingCell.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import UIKit

class PostGameRankingCell: UITableViewCell {
    @IBOutlet private var row: UIStackView!

    func setRow(values: [String]) {
        values.forEach {
            let field = UILabel()
            field.text = $0
            row.addArrangedSubview(field)
        }

        row.layoutIfNeeded()
    }
}
