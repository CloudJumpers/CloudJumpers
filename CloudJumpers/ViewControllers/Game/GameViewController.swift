import Combine
import SpriteKit

class GameViewController: UIViewController {
    static let MainStoryboard = "Main"
    static let EndGameViewControllerId = "EndGameViewController"

    private var gameEngine: GameEngine?
    private var scene: GameScene?
    private var joystick: Joystick?
    private var gameRules: GameRules?

    var lobby: GameLobby?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpSynchronizedStart()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameEngine = nil
        scene = nil
        joystick = nil
    }

    private func setUpSynchronizedStart() {
        lobby?.synchronizer?.updateCallback(setUpGame)
    }

    private func setUpGame() {
        print("setUpGame called at: \(LobbyUtils.getUnixTimestampMillis())") // TODO: remove once confident it works
        prepareGameEngine()
        setUpGameScene()
        setUpInputControls()
    }

    private func prepareGameEngine() {
        gameEngine = GameEngine(for: self, channel: lobby?.id)
        gameRules = TimeTrialGameRules()
    }

    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
        setUpGameEngine()
        setUpSKViewAndPresent(scene: scene)
    }

    private func setUpGameEngine() {
        guard let scene = scene else {
            fatalError("GameScene was not set up before GameEngine")
        }

        let blueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.cloudNodeSize,
            tolerance: CGVector(dx: 150, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...1.0,
            firstPlatformPosition: Constants.playerInitialPosition)

        let clouds = LevelGenerator.from(blueprint, seed: 69_420).map { Cloud(at: $0) }

        gameEngine?.setUpGame(with: clouds)
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

        guard let gameData = gameEngine?.metaData,
              let gameRules = gameRules
        else {
            return
        }

        if gameRules.hasGameEnd(with: gameData) {
            transitionToEndGame(state: TimeTrialGameEndState(playerEndTime: gameData.time))
        }

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
