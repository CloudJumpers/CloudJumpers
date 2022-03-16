import SpriteKit
import Combine

extension SKNode {
  class func unarchiveFromFile(file: String) -> SKNode? {
      if let path = Bundle.main.path(forResource: file, ofType: "sks") {
          // swiftlint:disable:next force_try
          let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
          let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)

          archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
              // swiftlint:disable:next force_cast
          let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
          archiver.finishDecoding()
          return scene
    } else {
      return nil
    }
  }

}

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
