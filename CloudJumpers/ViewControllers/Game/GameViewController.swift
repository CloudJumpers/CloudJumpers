import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            let gameEngine = SinglePlayerGameEngine(gameScene: scene, level: Level())
            scene.gameEngine = gameEngine

            let skView = view as? SKView
            skView?.ignoresSiblingOrder = true
            skView?.showsNodeCount = true
            skView?.showsFPS = true
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
    }

    override func loadView() {
        let sceneView = SKView()
        self.view = sceneView
    }
}
