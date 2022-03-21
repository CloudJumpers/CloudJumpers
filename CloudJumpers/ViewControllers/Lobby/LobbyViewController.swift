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
    @IBOutlet private var gameMode: UILabel!
    @IBOutlet private var readyButton: UIButton!
    @IBOutlet private var leaveButton: UIButton!

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
            // If we are returning from a child VC (game session), exit back to all lobbies menu
            moveToLobbies()
            return
        }
    }

    func setActiveLobby(id: EntityID, name: String, hostId: EntityID) {
        activeLobby = GameLobby(
            id: id,
            name: name,
            hostId: hostId,
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyNameChange: setLobbyName,
            onLobbyGameModeChange: setLobbyGameMode
        )
    }

    func setActiveLobby() {
        activeLobby = GameLobby(
            onLobbyStateChange: handleLobbyUpdate,
            onLobbyNameChange: setLobbyName,
            onLobbyGameModeChange: setLobbyGameMode
        )
    }

    @IBAction private func moveToLobbies() {
        guard activeLobby != nil else {
            return
        }

        self.activeLobby?.removeDeviceUser()
        self.activeLobby = nil

        self.navigationController?.popViewController(animated: true)
    }

    func moveToGame() {
        performSegue(
            withIdentifier: SegueIdentifier.lobbyToGame,
            sender: nil
        )
    }

    @IBAction private func onReadyButtonTap() {
        self.activeLobby?.toggleDeviceUserReadyStatus()
        leaveButton.isEnabled = false
    }

    // MARK: - Lobby management
    private func handleLobbyUpdate(_ lobby: GameLobby, _ state: LobbyState) {
        if state == .gameInProgress {
            moveToGame()
        } else if state == .disconnected {
            moveToLobbies()
        }
    }

    private func onLobbyDataChange() {
        lobbyUsersView.reloadData()

        guard let deviceUser = activeLobby?.users.first(where: { $0.id == AuthService().getUserId() }) else {
            return
        }

        leaveButton.isEnabled = !deviceUser.isReady
    }

    private func setLobbyName(_ name: String) {
        lobbyName.text = name
    }

    private func setLobbyGameMode(_ mode: String) {
        gameMode.text = mode
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
