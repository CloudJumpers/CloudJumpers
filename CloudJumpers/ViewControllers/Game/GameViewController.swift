import SpriteKit
import Combine

class GameViewController: UIViewController {
    static let MainStoryboard = "Main"
    static let EndGameViewControllerId = "EndGameViewController"

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

    override func loadView() {
        let sceneView = SKView()
        self.view = sceneView
    }

    private func createGameEngineSubscribers(for scene: GameScene) {
        addNodeSubscription = gameEngine?.addNodePublisher.sink { node in
            scene.addChild(node)
        }

        removeNodeSubscription = gameEngine?.removeNodePublisher.sink { node in
            node.removeAllChildren()
            node.removeFromParent()
        }

        endStateSubscription = stateMachine?.endPublisher.sink { state in
            self.transitionToEndGame(state: state)
        }
    }

    private func setUpGameEngine() {
        stateMachine = StateMachine()
        if let stateMachine = stateMachine {
            gameEngine = SinglePlayerGameEngine(stateMachine: stateMachine)
        }
    }

    private func setUpGameScene() {
        guard let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        createGameEngineSubscribers(for: scene)
        // Setup Game only after creating the subscribers
        gameEngine?.setupGame(with: Level())

        scene.scaleMode = .aspectFill
        presentGameScene(scene)
    }

    private func presentGameScene(_ scene: GameScene) {
        let skView = view as? SKView
        skView?.ignoresSiblingOrder = true
        skView?.showsNodeCount = true
        skView?.showsFPS = true
        skView?.presentScene(scene)
    }

    private func transitionToEndGame(state: TimeTrialGameEndState) {
        let storyboard = UIStoryboard(name: GameViewController.MainStoryboard, bundle: nil)

        guard let endGameViewController = storyboard
                .instantiateViewController(identifier: GameViewController.EndGameViewControllerId)
                as? EndGameViewController
        else {
            fatalError("Cannot find controller with identifier \(GameViewController.EndGameViewControllerId)")
        }

        let scores = state.scores
        let names = scores[1...].map { score in score.name }
        let highScores = scores[1...].map { score in "\(score.score)" }
        let playerScore = "\(scores[0].score)"

        endGameViewController.configure(names: names, scores: highScores, playerScore: playerScore)

        if var viewControllers = self.navigationController?.viewControllers {
            viewControllers[viewControllers.count - 1] = endGameViewController
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
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
