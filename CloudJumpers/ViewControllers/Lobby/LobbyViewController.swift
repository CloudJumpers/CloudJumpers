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
    @IBOutlet private var readyButton: UIButton!
    @IBOutlet private var leaveButton: UIButton!

    var activeListing: LobbyListing?
    var activeLobby: GameLobby?

    override func viewDidLoad() {
        super.viewDidLoad()
        lobbyUsersView.dataSource = self
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
                gameMode: listing.gameMode,
                hostId: listing.hostId
            )
        } else {
            setActiveLobby()
        }

        refreshGameModeMenu()
    }

    func setActiveLobby(id: NetworkID, name: String, gameMode: GameMode, hostId: NetworkID) {
        activeLobby = GameLobby(
            id: id,
            name: name,
            gameMode: gameMode,
            hostId: hostId,
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyDataChange: handleLobbyDataChange,
            onLobbyNameChange: setLobbyName,
            onLobbyGameModeChange: setLobbyGameMode
        )
    }

    func setActiveLobby() {
        activeLobby = GameLobby(
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyDataChange: handleLobbyDataChange,
            onLobbyNameChange: setLobbyName,
            onLobbyGameModeChange: setLobbyGameMode
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

    // MARK: - Lobby management
    private func handleLobbyUpdate(_ state: LobbyState) {
        if state == .gameInProgress {
            moveToGame()
        } else if state == .disconnected {
            moveToLobbies()
        }
    }

    private func handleLobbyDataChange() {
        lobbyUsersView.reloadData()
        refreshGameModeMenu()

        guard
            let lobby = activeLobby,
            let deviceUser = lobby.users.first(where: { $0.id == AuthService().getUserId() })
        else {
            return
        }

        leaveButton.isEnabled = !deviceUser.isReady
        gameMode.isEnabled = !deviceUser.isReady && lobby.userIsHost
    }

    private func setLobbyName(_ name: String) {
        lobbyName.text = name
    }

    private func setLobbyGameMode(_ mode: String) {
        gameMode.menu?.children.forEach { action in
            guard let action = action as? UIAction, action.title == mode else {
                return
            }

            action.state = action.title == mode ? .on : .off
        }
    }

    private func changeLobbyGameMode(action: UIAction) {
        guard let selectedGameMode = GameMode(rawValue: action.title) else {
            return
        }

        activeLobby?.changeGameMode(mode: selectedGameMode)
    }

    private func refreshGameModeMenu() {
        guard let lobby = activeLobby else {
            return
        }

        var gameModeOptions = [UIAction]()

        GameMode.allCases.forEach {
            let maxSupportedPlayers = $0.getMaxPlayer()

            if maxSupportedPlayers >= lobby.numUsers {
                gameModeOptions.append(UIAction(title: $0.rawValue, handler: changeLobbyGameMode))
            }
        }

        gameMode.menu = UIMenu(children: gameModeOptions)
        gameMode.isEnabled = lobby.userIsHost
        setLobbyGameMode(lobby.gameMode.rawValue)
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

        guard let lobbyUser = activeLobby?.users[indexPath.row], let lobbyUserCell = cell as? LobbyUserCell else {
            return cell
        }

        lobbyUserCell.setDisplayName(newDisplayName: lobbyUser.displayName)
        lobbyUserCell.setIsReady(isReady: lobbyUser.isReady)

        return cell
    }
}
