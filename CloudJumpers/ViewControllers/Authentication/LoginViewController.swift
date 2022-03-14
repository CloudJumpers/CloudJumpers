//
//  LoginViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 13/3/22.
//

import UIKit

private enum LoginConstants {
    static let success = "Welcome, "
    static let failure = "Log in failed, please verify credentials and try again."
}

class LoginViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var feedbackToast: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setUpOutcomeLabel()
    }

    @IBAction private func onLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        initiateLogIn(email: email, password: password)
    }

    private func initiateLogIn(email: String, password: String) {
        Task {
            let authService = AuthService()
            let loginOutcome = await authService.logIn(email: email, password: password)
            let displayName = authService.getUserDisplayName()

            let lm = LobbyManager()
            lm.createNewLobby(userId: authService.getUserId()!)

            self.updateOutcomeLabel(outcome: loginOutcome, name: displayName)
        }
    }

    private func setUpOutcomeLabel() {
        feedbackToast.alpha = AuthToastConstants.initialAlpha
        feedbackToast.textColor = UIColor.white
        feedbackToast.textAlignment = .center
        feedbackToast.layer.cornerRadius = 2
        feedbackToast.numberOfLines = 0
        feedbackToast.clipsToBounds = true
    }

    private func updateOutcomeLabel(outcome: Bool, name: String?) {
        if outcome, let displayName = name {
            feedbackToast.text = LoginConstants.success + displayName
            feedbackToast.backgroundColor = .green
        } else {
            feedbackToast.text = LoginConstants.failure
            feedbackToast.backgroundColor = .red
        }

        UIView.animate(
            withDuration: AuthToastConstants.appearSeconds,
            animations: { self.feedbackToast.alpha = AuthToastConstants.finalAlpha }
        )
    }
}
