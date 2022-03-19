import SpriteKit

class GameViewController: UIViewController {
    private var gameEngine: GameEngine?
    private var stateMachine: StateMachine?
    private var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGameEngine()
        setUpGameScene()
    }

    private func setUpGameEngine() {
        stateMachine = StateMachine()
        if let stateMachine = stateMachine {
            gameEngine = SinglePlayerGameEngine(stateMachine: stateMachine)
            gameEngine?.delegate = self
        }
    }

    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
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

// MARK: - GameEngineDelegate
extension GameViewController: GameEngineDelegate {
    func engine(_ engine: GameEngine, didEndGameWith state: GameState) {
        // TODO: Navigate to EndViewController
    }

    func engine(_ engine: GameEngine, addEntityWith node: SKNode) {
        scene?.addChild(node)
    }

    func engine(_ engine: GameEngine, addPlayerWith node: SKNode) {
        self.engine(engine, addEntityWith: node)
        scene?.cameraAnchorNode = node
    }

    func engine(_ engine: GameEngine, addControlWith node: SKNode) {
        scene?.addStaticChild(node)
    }
}
