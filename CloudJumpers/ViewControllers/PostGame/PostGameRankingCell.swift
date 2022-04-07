//
//  PostGameRankingCell.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import UIKit

class PostGameRankingCell: UITableViewCell {
    @IBOutlet private var rowHolder: UIView!
    @IBOutlet private var row: UIStackView!

    func highlight() {
        rowHolder.backgroundColor = .darkGray
    }

    func unhighlight() {
        rowHolder.backgroundColor = .clear
    }

    func setRow(values: [String]) {
        let toRemove = row.arrangedSubviews

        toRemove.forEach {
            $0.removeFromSuperview()
        }

        values.forEach {
            let field = UILabel()

            field.text = $0
            field.textAlignment = .center

            row.addArrangedSubview(field)
        }

        row.layoutIfNeeded()
    }
}
