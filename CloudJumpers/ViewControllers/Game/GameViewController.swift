import Combine
import SpriteKit

class GameViewController: UIViewController {
    static let MainStoryboard = "Main"
    static let EndGameViewControllerId = "EndGameViewController"

    private var gameEngine: GameEngine?
    private var scene: GameScene?
    private var joystick: Joystick?

    var lobby: GameLobby?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSynchronizedStart()

    }

    private func setUpSynchronizedStart() {
        lobby?.synchronizer?.updateCallback(setUpGame)
    }

    private func setUpGame() {
        print("setUpGame called at: \(LobbyUtils.getUnixTimestampMillis())") // TODO: remove once confident it works
        setUpGameEngine()
        setUpGameScene()
        setUpInputControls()
    }

    private func setUpGameEngine() {
        gameEngine = SinglePlayerGameEngine(for: self, channel: lobby?.id)
    }

    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
        gameEngine?.setUpGame()
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

    private func setUpInputControls() {
        guard let gameEngine = gameEngine else {
            return
        }

        let joystick = Joystick(at: Constants.joystickPosition, to: gameEngine)
        let jumpButton = JumpButton(at: Constants.jumpButtonPosition, to: gameEngine)

        scene?.addStaticChild(joystick)
        scene?.addStaticChild(jumpButton)

        self.joystick = joystick
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
        let playerScore = String(format: "%.1f", scores[0].score)

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
        gameEngine?.update(within: interval)
        gameEngine?.inputMove(by: joystick?.displacement ?? .zero)
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
        if let endState = state as? TimeTrialGameEndState {
            self.transitionToEndGame(state: endState)
        }
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
