//
//  LobbyViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet private var lobbyUsersView: UITableView!
    @IBOutlet private var lobbyName: UILabel!
    @IBOutlet private var gameMode: UIButton!
    @IBOutlet private var gameSeed: UITextField!
    @IBOutlet private var readyButton: UIButton!
    @IBOutlet private var leaveButton: UIButton!

    var activeListing: LobbyListing?
    var activeLobby: GameLobby?

    override func viewDidLoad() {
        super.viewDidLoad()
        lobbyUsersView.dataSource = self
        gameSeed.delegate = self
        navigationItem.hidesBackButton = true
        overrideUserInterfaceStyle = .light
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard isMovingToParent else {
            // If we are returning from a child VC (game session or postgame), exit back to all lobbies menu
            moveToLobbies()
            return
        }

        if let listing = activeListing {
            setActiveLobby(
                id: listing.lobbyId,
                name: listing.lobbyName,
                config: listing.config,
                hostId: listing.hostId
            )
        } else {
            setActiveLobby()
        }

        refreshGameModeMenu()
    }

    func setActiveLobby(id: NetworkID, name: String, config: PreGameConfig, hostId: NetworkID) {
        activeLobby = GameLobby(
            id: id,
            name: name,
            gameConfig: config,
            hostId: hostId,
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyDataChange: handleLobbyDataChange
        )
    }

    func setActiveLobby() {
        activeLobby = GameLobby(
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyDataChange: handleLobbyDataChange
        )
    }

    @IBAction private func moveToLobbies() {
        guard
            activeLobby != nil, // only run once
            let viewControllers = navigationController?.viewControllers,
            let lobbiesViewController = viewControllers.first(where: { $0 is LobbiesViewController })
        else {
            return
        }

        self.activeLobby?.removeDeviceUser()
        self.activeLobby = nil
        self.activeListing = nil

        self.navigationController?.popToViewController(lobbiesViewController, animated: true)
    }

    func moveToGame() {
        performSegue(
            withIdentifier: SegueIdentifier.lobbyToGame,
            sender: activeLobby
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let dest = segue.destination as? GameViewController else {
            return
        }

        dest.lobby = activeLobby
    }

    @IBAction private func onReadyButtonTap() {
        self.activeLobby?.toggleDeviceUserReadyStatus()
        leaveButton.isEnabled = false
        gameMode.isEnabled = false
    }

    @IBAction private func onSeedChange() {
        guard let lobby = activeLobby, lobby.userIsHost else {
            return
        }

        guard
            let newInput = gameSeed.text,
            let newSeed = Int(newInput)
        else {
            refreshGameSeed()
            return
        }

        activeLobby?.changeGameSeed(newSeed)
    }

    // MARK: - Lobby management
    private func handleLobbyUpdate(_ state: LobbyState) {
        if state == .gameInProgress {
            moveToGame()
        } else if state == .disconnected {
            moveToLobbies()
        }
    }

    private func handleLobbyDataChange() {
        guard
            let lobby = activeLobby,
            let deviceUser = lobby.users.first(where: { $0.id == AuthService().getUserId() })
        else {
            return
        }

        lobbyUsersView.reloadData()
        refreshGameModeMenu()
        refreshGameSeed()
        refreshLobbyName()

        leaveButton.isEnabled = !deviceUser.isReady
        gameMode.isEnabled = !deviceUser.isReady && lobby.userIsHost
        gameSeed.isEnabled = !deviceUser.isReady && lobby.userIsHost
    }

    private func refreshLobbyName() {
        lobbyName.text = activeLobby?.name ?? lobbyName.text
    }

    private func refreshGameSeed() {
        guard let lobby = activeLobby else {
            return
        }

        gameSeed.text = lobby.gameConfig.seed.description
    }

    private func refreshLobbyGameMode() {
        guard let mode = activeLobby?.gameConfig.name else {
            return
        }

        gameMode.menu?.children.forEach { action in
            guard let action = action as? UIAction, action.title == mode else {
                return
            }

            action.state = action.title == mode ? .on : .off
        }
    }

    private func changeLobbyGameMode(action: UIAction) {
        let selectedGameMode = GameModeFactory.createGameMode(name: action.title)
        activeLobby?.changeGameMode(mode: selectedGameMode)
    }

    private func refreshGameModeMenu() {
        guard let lobby = activeLobby else {
            return
        }

        var gameModeOptions = [UIAction]()

        GameModeFactory.getCompatibleModeNames(lobby.numUsers).forEach {
            gameModeOptions.append(UIAction(title: $0, handler: changeLobbyGameMode))
        }

        gameMode.menu = UIMenu(children: gameModeOptions)
        refreshLobbyGameMode()
    }
}

extension LobbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lobby = self.activeLobby else {
            return Int.zero
        }

        return lobby.numUsers
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LobbyConstants.LobbyUserCellIdentifier, for: indexPath)

        guard
            let lobbyUser = activeLobby?.orderedValidUsers[indexPath.row],
            let lobbyUserCell = cell as? LobbyUserCell,
            let lobbyHostId = activeLobby?.hostId
        else {
            return cell
        }

        lobbyUserCell.setIsHostLabelVisible(isVisible: lobbyUser.id == lobbyHostId)
        lobbyUserCell.setDisplayName(newDisplayName: lobbyUser.displayName)
        lobbyUserCell.setIsReady(isReady: lobbyUser.isReady)

        return cell
    }
}

extension LobbyViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
