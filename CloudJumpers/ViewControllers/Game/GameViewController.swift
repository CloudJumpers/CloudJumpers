import UIKit
import SpriteKit

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
