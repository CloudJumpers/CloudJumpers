import SpriteKit
import Combine

class GameViewController: UIViewController {
    private var gameEngine: GameEngine?
    private var stateMachine: StateMachine?
    private var addNodeSubscription: AnyCancellable?
    private var removeNodeSubscription: AnyCancellable?
    private var endStateSubscription: AnyCancellable?

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

        endStateSubscription = stateMachine?.endPublisher.sink { _ in
            // Navigate to end view
        }
    }

    private func setUpGameEngine() {
        stateMachine = StateMachine()
        if let stateMachine = stateMachine {
            gameEngine = SinglePlayerGameEngine(stateMachine: stateMachine)
        }
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

    func scene(_ scene: GameScene, didBeginContact contact: SKPhysicsContact) {
        gameEngine?.contactResolver.resolveBeginContact(contact: contact)
    }

    func scene(_ scene: GameScene, didEndContact contact: SKPhysicsContact) {
        gameEngine?.contactResolver.resolveEndContact(contact: contact)
    }
}
