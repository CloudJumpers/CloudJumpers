import SpriteKit
import Combine

class GameViewController: UIViewController {
    private var addNodeSubscription: AnyCancellable?
    private var removeNodeSubscription: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            let gameEngine = SinglePlayerGameEngine()
            scene.gameEngine = gameEngine

            createSubscribers(gameEngine: gameEngine, scene: scene)
            gameEngine.setupGame(level: Level())

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

    func createSubscribers(gameEngine: GameEngine, scene: GameScene) {

        addNodeSubscription = gameEngine.addNodePublisher.sink { node in
            scene.addChild(node)
        }

        removeNodeSubscription = gameEngine.removeNodePublisher.sink { node in
            node.removeAllChildren()
            node.removeFromParent()
        }
    }
}
