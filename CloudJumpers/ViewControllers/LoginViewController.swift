//
//  LoginViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 13/3/22.
//

import UIKit

private enum ToastConstants {
    static let success = "Successfully logged in."
    static let failure = "Log in failed, please verify entered credentials and try again."
    static let initialAlpha = 0.0
    static let finalAlpha = 1.0
    static let appearSeconds = 0.7
    static let padding = 10.0
}

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var feedbackToast: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutcomeLabel()
    }

    @IBAction func onLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        initiateLogIn(email: email, password: password)
    }

    private func initiateLogIn(email: String, password: String) {
        Task {
            let authService = AuthService()
            let loginOutcome = await authService.logIn(email: email, password: password)
            self.updateOutcomeLabel(outcome: loginOutcome)
        }
    }

    private func setUpOutcomeLabel() {
        feedbackToast.alpha = ToastConstants.initialAlpha
        feedbackToast.textColor = UIColor.white
        feedbackToast.textAlignment = .center
        feedbackToast.layer.cornerRadius = 2
        feedbackToast.numberOfLines = 0
        feedbackToast.clipsToBounds = true
    }

    private func updateOutcomeLabel(outcome: Bool) {
        feedbackToast.text = outcome ? ToastConstants.success : ToastConstants.failure
        feedbackToast.backgroundColor = outcome ? .green : .red
        UIView.animate(
            withDuration: ToastConstants.appearSeconds,
            animations: { self.feedbackToast.alpha = ToastConstants.finalAlpha }
        )
    }
}
