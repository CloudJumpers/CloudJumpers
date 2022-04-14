import Combine
import SpriteKit

class GameViewController: UIViewController {
    private var gameManager: GameManager?
    private var scene: GameScene?
    private var joystick: Joystick?
    private var gameRules: GameRules?

    private var isMovingToPostGame = false

    var lobby: GameLobby?
    var handlers: RemoteEventHandlers?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        isMovingToPostGame = false

        setUpSynchronizedStart()
        SoundManager.instance.stop(.background)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameManager = nil
        handlers = nil
        scene = nil
        joystick = nil
    }

    private func setUpSynchronizedStart() {
        guard let activeLobby = lobby else {
            return
        }

        let preGameManager = activeLobby.gameConfig.createPreGameManager(activeLobby.id)
        handlers = preGameManager.getEventHandlers()
        activeLobby.synchronizer?.updateCallback(setUpGame)
    }

    private func setUpGame() {
        print("setUpGame called at: \(LobbyUtils.getUnixTimestampMillis())") // TODO: remove once confident it works
        guard let config = lobby?.gameConfig as? InGameConfig, let handlers = handlers else {
            return
        }

        self.gameRules = config.getGameRules()

        gameManager = GameManager(
            rendersTo: scene,
            inChargeID: lobby?.hostId,
            handlers: handlers
        )

        setUpGameScene()
        setUpGameEngine()
        setUpInputControls()
        setUpSKViewAndPresent()
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
              let config = lobby?.gameConfig as? InGameConfig
        else {
            fatalError("GameScene, GameEngine, or configurated has not been initialized")
        }

        let authService = AuthService()
        guard let userId = authService.getUserId() else {
            fatalError("Cannot find user")
        }

        let userDisplayName = authService.getUserDisplayName()
        let userInfo = PlayerInfo(playerId: userId, displayName: userDisplayName)

        let allUsersInfo = config.getIdOrderedPlayers()

        let cloudBlueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.cloudNodeSize,
            tolerance: CGVector(dx: 150, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...1.0,
            firstPlatformPosition: Constants.playerInitialPosition,
            seed: config.seed
        )

        gameManager?.setUpGame(cloudBlueprint: cloudBlueprint)
        gameRules?.setUpForRule()
        gameRules?.setUpPlayers(userInfo, allPlayersInfo: allUsersInfo)
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
        guard let responder = gameManager else {
            return
        }

        let joystick = Joystick(at: Constants.joystickPosition, to: responder)
        let jumpButton = JumpButton(at: Constants.jumpButtonPosition, to: responder)
        let gameArea = GameArea(at: Constants.gameAreaPosition, to: responder)

        scene?.addChild(joystick, static: true)
        scene?.addChild(jumpButton, static: true)
        scene?.addChild(gameArea, static: false)

        self.joystick = joystick
    }

    private func transitionToEndGame(playerEndTime: Double) {
        guard
            !isMovingToPostGame,
            let activeLobby = lobby,
            let gameConfig = activeLobby.gameConfig as? PostGameConfig,
            let metaData = gameEngine?.metaData
        else { return }

        isMovingToPostGame = true

        let postGameManager = gameConfig.createPostGameManager(activeLobby.id, metaData: metaData)
        performSegue(withIdentifier: SegueIdentifier.gameToPostGame, sender: postGameManager)

        lobby?.onGameCompleted()
        lobby?.removeDeviceUser()
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
        dest.postGameManager?.submitForRanking()
    }
}

// MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) {
        guard let gameManager = gameManager,
              let gameRules = gameRules
        else { return }

        gameManager.update(within: interval)
        gameManager.updatePlayer(with: joystick?.displacement ?? .zero)

        if gameRules.hasGameEnd() {
            // TODO: maybe not expose meta data
            transitionToEndGame(playerEndTime: gameManager.metaData.time)
        }
    }

    func scene(_ scene: GameScene, nodeFromNodeCore nodeCore: NodeCore) -> Node? {
        gameManager?.node(from: nodeCore)
    }

    func scene(_ scene: GameScene, didBeginContactBetween nodeA: Node, and nodeB: Node) {
        gameManager?.beginContact(between: nodeA, and: nodeB)
    }

    func scene(_ scene: GameScene, didEndContactBetween nodeA: Node, and nodeB: Node) {
        gameManager?.endContact(between: nodeA, and: nodeB)
    }

    func sceneDidFinishUpdate(_ scene: GameScene) {
        <#code#>
    }
}
