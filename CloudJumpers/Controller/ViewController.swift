import UIKit
import SpriteKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: Constants.gameSceneSize)
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override func loadView() {
        let sceneView = SKView()        
        self.view = sceneView
    }
}
