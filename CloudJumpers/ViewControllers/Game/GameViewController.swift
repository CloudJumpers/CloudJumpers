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
        SoundManager.instance.stop(.background)
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
        guard let mode = lobby?.gameMode else {
            return
        }
        switch mode {
        case .timeTrial:
            gameRules = TimeTrialGameRules()
        case .raceTop:
            gameRules = RaceTopGameRules(with: lobby)
        }

        prepareGameEngine()
        setUpGameScene()
        setUpGameEngine()
        setUpInputControls()
        setUpSKViewAndPresent()

    }

    private func prepareGameEngine() {
        gameEngine = GameEngine(for: self, channel: lobby?.id)
    }

    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
    }

    private func setUpGameEngine() {
        guard let scene = scene,
              let gameEngine = gameEngine
        else {
            fatalError("GameScene was not set up or GameEngine was not prepared")
        }

        let blueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.cloudNodeSize,
            tolerance: CGVector(dx: 150, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...1.0,
            firstPlatformPosition: Constants.playerInitialPosition,
            seed: 161_001
        )

        gameRules?.prepareGameModes(gameEngine: gameEngine, blueprint: blueprint)

    }

    private func setUpSKViewAndPresent() {
        guard let scene = scene else {
            fatalError("GameScene was not set up")
        }
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
        guard
            let activeLobby = lobby,
            let score = state.scores.first?.score
        else {
            return
        }

        switch activeLobby.gameMode {
        case.timeTrial:
            let gameData = TimeTrialData(
                lobbyId: activeLobby.id,
                playerId: activeLobby.hostId,
                playerName: AuthService().getUserDisplayName(),
                seed: 161_001, // TODO: find a way to get seed
                gameMode: activeLobby.gameMode.rawValue,
                completionTime: score
            )

            let timeTrialManager = TimeTrialsManager(gameData)
            performSegue(withIdentifier: SegueIdentifier.gameToPostGame, sender: timeTrialManager)
        default:
            return
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard
            let dest = segue.destination as? PostGameViewController,
            let manager = sender as? PostGameManager
        else {
            return
        }

        dest.postGameManager = manager
        dest.postGameManager?.submitLocalData()
    }
}

// MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) {
        gameEngine?.update(within: interval)
        gameEngine?.updatePlayer(with: joystick?.displacement ?? .zero)

        guard let gameData = gameEngine?.metaData,
              let gameRules = gameRules
        else {
            return
        }
        let newModeEvents = gameRules.createGameEvents(with: gameData)
        newModeEvents.forEach({ gameEngine?.eventManager.add($0) })

        if gameRules.hasGameEnd(with: gameData) {
            // TO DO: streamlined this
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
