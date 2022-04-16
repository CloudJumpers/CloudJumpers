import Combine
import SpriteKit

class GameViewController: UIViewController {
    private var gameManager: GameManager?
    private var scene: GameScene?
    private var joystick: Joystick?

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let dest = segue.destination as? PostGameViewController,
              let manager = sender as? PostGameManager
        else { return }

        dest.postGameManager = manager
        dest.postGameManager?.submitForRanking()
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
        guard let config = lobby?.gameConfig as? InGameConfig, let handlers = handlers else {
            return
        }

        gameManager = GameManager(
            rendersTo: scene,
            handlers: handlers,
            rules: config.getGameRules(),
            achievementProcessor: config.getAchievementProcessor()
        )

        setUpGameScene()
        setUpGameManager()
        setUpInputControls()
        setUpSKViewAndPresent()
    }

    // MARK: - Game Set-up Methods
    private func setUpGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene.sks was not found!")
        }

        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
    }

    private func setUpGameManager() {
        guard let scene = scene,
              let config = lobby?.gameConfig as? InGameConfig
        else { fatalError("GameScene, GameEngine, or configurated has not been initialized") }

        let authService = AuthService()
        guard let userId = authService.getUserId() else {
            fatalError("Cannot find user")
        }

        let userDisplayName = authService.getUserDisplayName()
        let userInfo = PlayerInfo(playerId: userId, displayName: userDisplayName)
        let allUsersInfo = config.getIdOrderedPlayers()

        let blueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.cloudNodeSize,
            tolerance: CGVector(dx: 150, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...1.0,
            firstPlatformPosition: Constants.playerInitialPosition,
            seed: config.seed
        )

        gameManager?.setUpGame(with: blueprint, playerInfo: userInfo, allPlayersInfo: allUsersInfo)
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

    // MARK: - Helper Methods
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

    private func transitionToEndGame(with completionData: LocalCompletionData) {
        guard !isMovingToPostGame,
              let activeLobby = lobby,
              let gameConfig = activeLobby.gameConfig as? PostGameConfig
        else { return }

        isMovingToPostGame = true

        let postGameManager = gameConfig.createPostGameManager(activeLobby.id, completionData: completionData)

        lobby?.onGameCompleted()
        lobby?.removeDeviceUser()
        lobby = nil

        performSegue(withIdentifier: SegueIdentifier.gameToPostGame, sender: postGameManager)
    }
}

// MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    func scene(_ scene: GameScene, updateWithin interval: TimeInterval) {
        guard let lobby = lobby,
              let gameManager = gameManager
        else {
            return
        }
        gameManager.update(within: interval)
        gameManager.inputMove(by: joystick?.displacement ?? .zero)

        // Check if player is host for each update iteration, enable as needed
        // TODO: Bring this to a callback if possible to reduce the need to check everytime
        if lobby.userIsHost && !gameManager.isHost {
            gameManager.enableHostStatus()
        }
    }
}

// MARK: - GameManagerDelegate
extension GameViewController: GameManagerDelegate {
    func manager(_ manager: GameManager, didEndGameWith completionData: LocalCompletionData) {
        transitionToEndGame(with: completionData)
    }
}
