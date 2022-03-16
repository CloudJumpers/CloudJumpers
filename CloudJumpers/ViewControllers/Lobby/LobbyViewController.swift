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

    var activeLobby: NetworkedLobby?
    var lobbyRef: DatabaseReference?

    @IBAction func onExit(_ sender: Any) {
        self.activeLobby?.exitLobby()
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lobbyUsersView.dataSource = self
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
        }
    }

    private func tearDownLobbiesListener() {
        lobbyRef?.removeAllObservers()
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
        guard let lobby = self.activeLobby else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = lobby.allUsers[indexPath.row].displayName
        return cell
    }
}
