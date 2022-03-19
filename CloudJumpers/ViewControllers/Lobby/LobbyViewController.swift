//
//  LobbyViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit
import FirebaseDatabase

private typealias firebaseStructure = [String: [String: Any]]

class LobbyViewController: UIViewController {
    @IBOutlet private var lobbyUsersView: UITableView!
    @IBOutlet private var lobbyName: UILabel!
    @IBOutlet private var gameMode: UILabel!
    @IBOutlet private var readyButton: UIButton!
    @IBOutlet private var leaveButton: UIButton!

    var activeLobby: NetworkedLobby?
    var lobbyRef: DatabaseReference?

    @IBAction private func onExit() {
        self.activeLobby?.exitLobby()
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
        setupLobbyListeners()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tearDownLobbiesListener()
        activeLobby = nil
    }

    private func setupLobbyListeners() {
        lobbyRef?.observe(.childAdded) { snapshot in
            self.handleUpdate(snapshot: snapshot)
        }

        lobbyRef?.observe(.childChanged) { snapshot in
            self.handleUpdate(snapshot: snapshot)
        }

        lobbyRef?.observe(.childRemoved) { snapshot in
            self.handleLeave(snapshot: snapshot)
        }
    }

    private func handleUpdate(snapshot: DataSnapshot) {
        if
            let value = snapshot.value as? firebaseStructure
        {
            updateLobbyUsers(userDict: value)
            lobbyUsersView.reloadData()
        } else if let value = snapshot.value as? String {
            switch snapshot.key {
            case LobbyKeys.lobbyName:
                setLobbyName(name: value)
            case LobbyKeys.gameMode:
                setLobbyGameMode(mode: value)
            default:
                return
            }
        }
    }

    private func handleLeave(snapshot: DataSnapshot) {
        if
            snapshot.key == LobbyKeys.hostId,
            let hostId = snapshot.value as? String,
            hostId == self.activeLobby?.hostId
        {
            self.onExit()
        }
    }

    private func handleSelfReadyUpdate(isReady: Bool) {
        leaveButton.isEnabled = !isReady
        isReady ? activeLobby?.setUserReady() : activeLobby?.setUserNotReady()
    }

    private func setLobbyName(name: String) {
        lobbyName.text = name
    }

    private func setLobbyGameMode(mode: String) {
        gameMode.text = mode
    }

    private func updateLobbyUsers(userDict: firebaseStructure) {
        self.activeLobby?.removeAllOtherUsers()

        userDict.forEach { userId, attributeKeyVal in
            guard
                let displayName = attributeKeyVal[LobbyKeys.participantName] as? String,
                let isReady = attributeKeyVal[LobbyKeys.participantReady] as? Bool
            else {
                return
            }

            let user = LobbyUser(id: userId, displayName: displayName, isReady: isReady)
            self.activeLobby?.addUser(newUser: user)

            if userId == AuthService().getUserId() {
                handleSelfReadyUpdate(isReady: isReady)
            }
        }
    }

    private func tearDownLobbiesListener() {
        lobbyRef?.removeAllObservers()
    }

    func moveToGame() {
        performSegue(
            withIdentifier: LobbyConstants.lobbyToGameSegueIdentifier,
            sender: nil
        )
    }
}

extension LobbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lobby = self.activeLobby else {
            return Int.zero
        }

        return lobby.allUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LobbyConstants.LobbyUserCellIdentifier, for: indexPath)

        guard let lobbyUser = activeLobby?.allUsers[indexPath.row], let lobbyUserCell = cell as? LobbyUserCell else {
            return cell
        }

        lobbyUserCell.setDisplayName(newDisplayName: lobbyUser.displayName)
        lobbyUserCell.setIsReady(isReady: lobbyUser.isReady)

        return cell
    }
}
