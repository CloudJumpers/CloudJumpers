//
//  SignUpViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit

private enum SignUpConstants {
    static let success = "Successfully signed up."
    static let failure = "Unsuccessful sign up, please try again."
}

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var feedbackToast: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutcomeLabel()
    }

    @IBAction func signUp() {
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }

        initiateSignUp(name: name, email: email, password: password)
    }

    private func initiateSignUp(name: String, email: String, password: String) {
        Task {
            let authService = AuthService()
            let signUpOutcome = await authService.signUp(email: email, password: password, name: name)
            updateOutcomeLabel(outcome: signUpOutcome)
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

    private func updateOutcomeLabel(outcome: Bool) {
        if outcome {
            feedbackToast.text = SignUpConstants.success
            feedbackToast.backgroundColor = .green
        } else {
            feedbackToast.text = SignUpConstants.failure
            feedbackToast.backgroundColor = .red
        }

        UIView.animate(
            withDuration: AuthToastConstants.appearSeconds,
            animations: { self.feedbackToast.alpha = AuthToastConstants.finalAlpha }
        )
    }
}
