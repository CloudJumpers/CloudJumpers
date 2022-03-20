//
//  LandingViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 20/3/22.
//

import Foundation
import UIKit

class LandingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let auth = AuthService()
        auth.isLoggedIn() ? moveToLobbies() : moveToLoginOptions()
    }

    private func moveToLoginOptions() {
        performSegue(withIdentifier: SegueIdentifier.landingToLogin, sender: nil)
    }

    private func moveToLobbies() {
        performSegue(withIdentifier: SegueIdentifier.landingToLobbies, sender: nil)
    }
}
