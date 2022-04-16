//
//  FBAchievementDataDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation
import FirebaseDatabase

class FBAchievementDataDelegate: AchievementDataDelegate {
    private let achievementReference: DatabaseReference

    weak var achievement: Achievement?

    required init(_ userId: NetworkID) {
        self.achievementReference = Database
            .database()
            .reference(withPath: AchievementKeys.root)
            .child(userId)
    }

    func fetchAchievementData(_ key: String) {
        achievementReference.child(key).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value as? Int else {
                return
            }

            self?.achievement?.genericLoad(key, value)
        }
    }

    func incrementAchievementData(_ key: String, by: Int) {
        achievementReference.child(key).setValue(ServerValue.increment(NSNumber(value: by)))
    }

    deinit {
        achievementReference.removeAllObservers()
    }
}
