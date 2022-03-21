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
    var lobbyUpdateListener: ListenerDelegate?

    @IBAction private func terminateLobbyConnection() {
        guard lobbyUpdateListener != nil else {
            return
        }

        lobbyUpdateListener = nil
        self.activeLobby?.removeDeviceUser()
        self.activeLobby = nil

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction private func onReadyButtonTap() {
        self.activeLobby?.toggleReady()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lobbyUsersView.dataSource = self
        navigationItem.hidesBackButton = true
        overrideUserInterfaceStyle = .light
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard isMovingToParent, let lobbyId = activeLobby?.id else {
            // If we are returning from a child VC (game session) or do not have a lobby initialized,
            // exit back to all lobbies menu
            terminateLobbyConnection()
            return
        }

        lobbyUpdateListener = FirebaseListenerDelegate(
            lobbyId: lobbyId,
            onUserAdd: onUserAdd,
            onUserChange: onUserChange,
            onUserRemove: onUserRemove,
            onLobbyChange: onLobbyChange
        )
    }

    func onLobbyUpdate(_ lobby: GameLobby, _ state: LobbyState) {
        if state == .gameInProgress {
            moveToGame()
        } else if state == .disconnected {
            terminateLobbyConnection()
        }
    }

    func moveToGame() {
        performSegue(
            withIdentifier: SegueIdentifier.lobbyToGame,
            sender: nil
        )
    }

    // MARK: User management
    private func onUserAdd(_ user: LobbyUser) {
        activeLobby?.addUser(newUser: user)
        lobbyUsersView.reloadData()
    }

    private func onUserChange(_ user: LobbyUser) {
        if user.id == AuthService().getUserId() {
            handleSelfReadyUpdate(isReady: user.isReady)
        } else {
            activeLobby?.updateOtherUser(user)
        }

        lobbyUsersView.reloadData()
    }

    private func onUserRemove(_ user: LobbyUser) {
        if user.id == activeLobby?.hostId {
            terminateLobbyConnection()
        }

        activeLobby?.removeOtherUser(userId: user.id)
        lobbyUsersView.reloadData()
    }

    private func handleSelfReadyUpdate(isReady: Bool) {
        leaveButton.isEnabled = !isReady
        isReady ? activeLobby?.setUserReady() : activeLobby?.setUserNotReady()
    }

    // MARK: Lobby management
    private func onLobbyChange(_ key: String, _ value: String) {
        switch key {
        case LobbyKeys.lobbyName:
            setLobbyName(name: value)
        case LobbyKeys.gameMode:
            setLobbyGameMode(mode: value)
        default:
            return
        }
    }

    private func setLobbyName(name: String) {
        lobbyName.text = name
    }

    private func setLobbyGameMode(mode: String) {
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
