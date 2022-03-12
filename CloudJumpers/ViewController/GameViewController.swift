//
//  GameViewController.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    // MARK: View Controller overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        view = SKView(frame: view.bounds)

        if let view = self.view as! SKView? {
            // Initialise the scene
            let scene = GameScene(size: view.bounds.size) // <-- IMPORTANT: Initialise your first scene (as you have no .sks)

            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            // Scene properties
            view.showsPhysics = false
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}
