import Combine
import SpriteKit

class GameViewController: UIViewController {
    private var gameEngine: GameEngine?
    private var scene: GameScene?
    private var joystick: Joystick?

    private var isMovingToPostGame = false

    var lobby: GameLobby?

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
        let gameRules: GameRules
        switch mode {
        case .timeTrial:
            gameRules = TimeTrialGameRules()
        case .raceTop:
            gameRules = RaceTopGameRules()
        }
        gameEngine = GameEngine(
            rendersTo: self,
            rules: gameRules,
            inChargeID: lobby?.hostId,
            channel: lobby?.id)

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
              let gameEngine = gameEngine
        else {
            fatalError("GameScene was not set up or GameEngine was not prepared")
        }

        let authService = AuthService()
        guard let userId = authService.getUserId(),
              let allUsersSortedById = lobby?.orderedValidUsers
        else {
            fatalError("Cannot find user")
        }

        let userInfo = AuthInfo(userId: userId, displayName: authService.getUserDisplayName())
        let allUsersInfo = allUsersSortedById.map({ AuthInfo(userId: $0.id, displayName: $0.displayName) })

        let seed = 161_001

        let cloudBlueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.cloudNodeSize,
            tolerance: CGVector(dx: 150, dy: Constants.jumpImpulse.dy),
            xToleranceRange: 0.4...1.0,
            yToleranceRange: 0.4...1.0,
            firstPlatformPosition: Constants.playerInitialPosition,
            seed: seed
        )

        let powerUpBlueprint = Blueprint(
            worldSize: scene.size,
            platformSize: Constants.powerUpNodeSize,
            tolerance: CGVector(dx: 400, dy: 800),
            xToleranceRange: 0.5...1.0,
            yToleranceRange: 0.5...1.0,
            firstPlatformPosition: Constants.playerInitialPosition, seed: seed * 2)

        gameEngine.setUpGame(
            cloudBlueprint: cloudBlueprint,
            powerUpBlueprint: powerUpBlueprint,
            playerInfo: userInfo,
            allPlayersInfo: allUsersInfo)

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
        let gameArea = GameArea(at: Constants.gameAreaPosition, to: gameEngine)

        scene?.addChild(joystick, static: true)
        scene?.addChild(jumpButton, static: true)
        scene?.addChild(gameArea, static: false)

        self.joystick = joystick
    }

    private func transitionToEndGame(playerEndTime: Double) {
        guard
            !isMovingToPostGame,
            let activeLobby = lobby,
            let deviceUserId = AuthService().getUserId()
        else {
            return
        }

        isMovingToPostGame = true

        switch activeLobby.gameMode {
        case .timeTrial:
            let gameCompletionData = TimeTrialData(
                playerId: activeLobby.hostId,
                playerName: AuthService().getUserDisplayName(),
                completionTime: playerEndTime
            )

            let timeTrialManager = TimeTrialsManager(gameCompletionData, 161_001, activeLobby.id)
            performSegue(withIdentifier: SegueIdentifier.gameToPostGame, sender: timeTrialManager)
        case .raceTop:
            let gameCompletionData = RaceToTopData(
                playerId: deviceUserId,
                playerName: AuthService().getUserDisplayName(),
                completionTime: playerEndTime
            )

            let raceToTopManager = RaceToTopManager(gameCompletionData, 161_001, activeLobby.id)
            performSegue(withIdentifier: SegueIdentifier.gameToPostGame, sender: raceToTopManager)
        }

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
        guard let gameEngine = gameEngine else {
            return
        }
        gameEngine.update(within: interval)
        gameEngine.updatePlayer(with: joystick?.displacement ?? .zero)

        if gameEngine.hasGameEnd {
            // TO DO: maybe not expose meta data
            transitionToEndGame(playerEndTime: gameEngine.metaData.time)
        }

    }

    func scene(_ scene: GameScene, didBeginContact contact: SKPhysicsContact) {
        gameEngine?.contactResolver.resolveBeginContact(contact: contact)
    }

    func scene(_ scene: GameScene, didEndContact contact: SKPhysicsContact) {
        gameEngine?.contactResolver.resolveEndContact(contact: contact)
    }
}

// MARK: - SpriteSystemDelegate
extension GameViewController: SpriteSystemDelegate {
    func spriteSystem(_ system: SpriteSystem, addNode node: SKNode, static: Bool) {
        scene?.addChild(node, static: `static`)
    }

    func spriteSystem(_ system: SpriteSystem, removeNode node: SKNode) {
        scene?.removeChild(node)
    }

    func spriteSystem(_ system: SpriteSystem, bindCameraTo node: SKNode) {
        scene?.cameraAnchorNode = node
    }
}
