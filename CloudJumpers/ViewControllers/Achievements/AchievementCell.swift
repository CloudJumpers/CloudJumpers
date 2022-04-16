//
//  AchievementCell.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import UIKit

private struct ProgressText {
    var first: String
    var second: String

    var text: String {
        "\(first) / \(second)"
    }
}

class AchievementCell: UICollectionViewCell {
    @IBOutlet private var achievementTitle: UILabel!
    @IBOutlet private var achievementDesc: UILabel!
    @IBOutlet private var achievmentImage: UIImageView!
    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var progressDesc: UILabel!

    private var progressText = ProgressText(first: "-", second: "-")

    func setTitle(_ title: String) {
        achievementTitle.text = title
    }

    func setDescription(_ description: String) {
        achievementDesc.text = description
    }

    func setImage(_ imageName: String) {
        achievmentImage.image = Images(rawValue: imageName)?.image
    }

    func setUnlockStatus(_ isUnlocked: Bool) {
        achievmentImage.layer.opacity = isUnlocked ? 1.0 : 0.25
    }

    func setRequired(_ required: String) {
        progressText.second = required
        progressDesc.text = progressText.text
    }

    func setCurrent(_ current: String) {
        progressText.first = current
        progressDesc.text = progressText.text
    }

    func setProgressBar(_ progress: Double) {
        progressBar.progress = Float(progress)
    }
}
