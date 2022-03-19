import SpriteKit
import Combine

class GameViewController: UIViewController {
    private var gameEngine: GameEngine?
    private var addNodeSubscription: AnyCancellable?
    private var removeNodeSubscription: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGameEngine()
        setUpGameScene()
    }

    private func setUpSubscribers(for scene: GameScene) {
        addNodeSubscription = gameEngine?.addNodePublisher.sink { node in
            scene.addChild(node)
        }

        removeNodeSubscription = gameEngine?.removeNodePublisher.sink { node in
            node.removeAllChildren()
            node.removeFromParent()
        }
    }

    private func setUpGameEngine() {
        gameEngine = SinglePlayerGameEngine()
    }

    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        setUpSubscribers(for: scene)
        gameEngine?.setupGame(with: Level())
        setUpSKViewAndPresent(scene: scene)
    }

    private func setUpSKViewAndPresent(scene: SKScene) {
        let skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = true
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        skView.showsFPS = true
        skView.presentScene(scene)
        view = skView
    }
}

// MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) {
        gameEngine?.update(interval)
    }

    func scene(_ scene: GameScene, didBeginTouchAt location: CGPoint) {
        gameEngine?.touchableManager.handleTouchBeganEvent(location: location)
    }

    func scene(_ scene: GameScene, didMoveTouchAt location: CGPoint) {
        gameEngine?.touchableManager.handleTouchMovedEvent(location: location)
    }

    func scene(_ scene: GameScene, didEndTouchAt location: CGPoint) {
        gameEngine?.touchableManager.handleTouchEndedEvent(location: location)
    }

    func scene(_ scene: GameScene, didBeginContactBetween nodeA: SKNode, and nodeB: SKNode) {
        let newEvent = Event(type: .contact(nodeA: nodeA, nodeB: nodeB))
        gameEngine?.eventManager.eventsQueue.append(newEvent)
    }

    func scene(_ scene: GameScene, didEndContactBetween nodeA: SKNode, and nodeB: SKNode) {
        let newEvent = Event(type: .endContact(nodeA: nodeA, nodeB: nodeB))
        gameEngine?.eventManager.eventsQueue.append(newEvent)
    }
}
