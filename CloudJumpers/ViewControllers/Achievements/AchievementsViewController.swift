//
//  AchievementsViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController {
    @IBOutlet private var achievementsCollectionView: UICollectionView!
    private var achievements: [Achievement] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print("DID LOAD ACHIEVEMENTS")

        achievementsCollectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let userId = AuthService().getUserId() else {
            return
        }

        achievements = AchievementFactory.createAchievements(userId: userId, onLoad: updateData)
        updateData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        achievements.removeAll()
    }

    private func updateData() {
        achievementsCollectionView.reloadData()
    }
}

extension AchievementsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        achievements.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AchievementConstants.cellReuseIdentifier,
            for: indexPath
        )

        guard let achievementCell = cell as? AchievementCell else {
            return cell
        }

        let title = achievements[indexPath.item].title
        let description = achievements[indexPath.item].description
        let isUnlocked = achievements[indexPath.item].isUnlocked
        let currProgress = achievements[indexPath.item].currentProgress
        let reqProgress = achievements[indexPath.item].requiredProgress

        achievementCell.setTitle(title)
        achievementCell.setDescription(description)
        achievementCell.setUnlockStatus(isUnlocked)
        achievementCell.setCurrent(currProgress ?? "-")
        achievementCell.setRequired(reqProgress)

        return achievementCell
    }
}
