import SpriteKit
import RenderCore

class GameViewController: UIViewController {
    private var gameManager: GameManager?
    private var scene: GameScene?
    private var joystick: Joystick?

    private var isMovingToPostGame = false

    var lobby: GameLobby?
    var handlers: RemoteEventHandlers?

    var skView: SKView?

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
        view = nil
        scene = nil
        skView = nil
        gameManager = nil
        handlers = nil
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
        setUpGame()
    }

    private func setUpGame() {
        guard let activeLobby = lobby,
              let config = activeLobby.gameConfig as? InGameConfig,
              let handlers = handlers else {
            return
        }

        setUpGameScene()

        gameManager = GameManager(
            rendersTo: scene,
            handlers: handlers,
            rules: config.getGameRules(),
            achievementProcessor: config.getAchievementProcessor()
        )

        setUpGameManager()
        setUpInputControls()
        setUpSKView()

        activeLobby.synchronizer?.updateCallback(startGame)
    }

    private func startGame() {
        presentSKView()
    }

    // MARK: - Game Set-up Methods
    private func setUpGameScene() {
        let scene = GameScene(size: CGSize(width: 750, height: 1_000))
        scene.sceneDelegate = self
        scene.scaleMode = .aspectFill
        self.scene = scene
        addHomeButton()
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
            tolerance: CGVector(dx: Constants.jumpImpulse.dy, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...0.8,
            firstPlatformPosition: Constants.playerInitialPosition,
            seed: config.seed
        )
        gameManager?.delegate = self

        let velocityInfo = VelocityGenerationInfo(
            velocityRange: -100.0...100.0,
            seed: config.seed
        )

        gameManager?.setUpGame(with: blueprint, velocity: velocityInfo,
                               playerInfo: userInfo, allPlayersInfo: allUsersInfo)
    }

    private func setUpInputControls() {
        guard let responder = gameManager else {
            return
        }

        let joystick = Joystick(at: Constants.joystickPosition, to: responder)
        let jumpButton = JumpButton(at: Constants.jumpButtonPosition, to: responder)

        scene?.addChild(joystick, static: true)
        scene?.addChild(jumpButton, static: true)

        self.joystick = joystick
    }

    private func setUpSKView() {
        skView = SKView(frame: view.frame)
        skView?.isMultipleTouchEnabled = true
        skView?.ignoresSiblingOrder = true
        skView?.showsNodeCount = true
        skView?.showsFPS = true
    }

    // MARK: - Helper Methods
    private func presentSKView() {
        skView?.presentScene(scene)
        view = skView
    }

    private func addHomeButton() {
        let button = HomeButton(texture: Texture.texture(of: Buttons.home.frame), size: Constants.homeButtonSize)
        button.configure(at: Constants.homeButtonPosition)
        button.delegate = self
        scene?.addChild(button, static: true)
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
        else { return }

        gameManager.update(within: interval)
        gameManager.inputMove(by: joystick?.displacement ?? .zero)

        // Check if player is host for each update iteration, enable as needed
        if lobby.userIsHost && !gameManager.isHost {
            gameManager.enableHostStatus()
        }
    }

    func scene(_ scene: GameScene, didCompletedTouchAt location: CGPoint) {
        gameManager?.activatePowerUp(at: location)
    }
}

// MARK: - GameManagerDelegate
extension GameViewController: GameManagerDelegate {
    func manager(_ manager: GameManager, didEndGameWith completionData: LocalCompletionData) {
        transitionToEndGame(with: completionData)
    }
}

// MARK: - HomeButtonDelegate
extension GameViewController: HomeButtonDelegate {
    func didPressHomeButton() {
        lobby?.removeDeviceUser()

        performSegue(withIdentifier: SegueIdentifier.gameToLobbies, sender: nil)
    }
}
