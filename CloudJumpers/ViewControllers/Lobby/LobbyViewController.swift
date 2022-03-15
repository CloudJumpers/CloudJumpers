//
//  LobbyViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet private var lobbyName: UILabel!
    @IBOutlet private var gameMode: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetaData()
    }

    private func setupMetaData() {
        lobbyName.text = "Test"
        gameMode.text = GameModes.TimeTrial.rawValue
    }
}
