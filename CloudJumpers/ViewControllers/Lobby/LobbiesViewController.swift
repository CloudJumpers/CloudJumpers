//
//  LobbiesViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 14/3/22.
//

import UIKit
import FirebaseDatabase

class LobbiesViewController: UIViewController {
    @IBOutlet private var lobbiesCollectionView: UICollectionView!

    private(set) var lobbies: [LobbyListing] = [LobbyListing]()
    private var lobbiesRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        lobbiesCollectionView.dataSource = self
        lobbiesCollectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshDataSource()
        setUpLobbiesListener()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tearDownLobbiesListener()
        refreshDataSource()
    }

    @IBAction private func unwindToLobbies(_ unwindSegue: UIStoryboardSegue) {
        // This view controller is used as an unwind destination
    }

    @IBAction private func showUserAchievements() {
        moveToAchievements()
    }

    @IBAction private func signUserOut() {
        let auth = AuthService()
        auth.logOut()
        moveToLogin()
    }

    @IBAction private func createNewLobby(_ sender: Any) {
        moveToLobby(listing: nil)
    }

    private func setUpLobbiesListener() {
        lobbiesRef = Database.database().reference(withPath: LobbyKeys.root)

        lobbiesRef?.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? NSDictionary,
                let hostId = value[LobbyKeys.hostId] as? NetworkID,
                let lobbyName = value[LobbyKeys.lobbyName] as? String,
                let gameModeString = value[LobbyKeys.gameMode] as? String,
                let isOpen = value[LobbyKeys.isOpen] as? Bool,
                let participants = value[LobbyKeys.participants] as? NSDictionary
            else {
                return
            }

            let gameMode = GameModeFactory.createGameMode(name: gameModeString)

            let listing = LobbyListing(
                lobbyId: snapshot.key, hostId: hostId, lobbyName: lobbyName,
                config: gameMode, occupancy: participants.count, isOpen: isOpen)

            self.addLobbyListing(listing)
            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childRemoved) { snapshot in
            self.removeLobbyListing(lobbyId: snapshot.key)
            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childChanged) { snapshot in
            guard
                let value = snapshot.value as? NSDictionary,
                let occupancy = value[LobbyKeys.participants] as? NSDictionary,
                let name = value[LobbyKeys.lobbyName] as? String,
                let hostId = value[LobbyKeys.hostId] as? NetworkID,
                let gameModeString = value[LobbyKeys.gameMode] as? String,
                let isOpen = value[LobbyKeys.isOpen] as? Bool
            else {
                return
            }

            let gameMode = GameModeFactory.createGameMode(name: gameModeString)

            let lobbyListing = LobbyListing(
                lobbyId: snapshot.key,
                hostId: hostId,
                lobbyName: name,
                config: gameMode,
                occupancy: occupancy.count,
                isOpen: isOpen
            )

            self.updateLobbyListing(lobbyListing)
            self.lobbiesCollectionView.reloadData()
        }
    }

    private func addLobbyListing(_ listing: LobbyListing) {
        lobbies.append(listing)
    }

    private func removeLobbyListing(lobbyId: NetworkID) {
        lobbies = lobbies.filter { $0.lobbyId != lobbyId }
    }

    private func updateLobbyListing(_ listing: LobbyListing) {
        guard let index = lobbies.firstIndex(where: { $0.lobbyId == listing.lobbyId }) else {
            return
        }

        lobbies[index] = listing
    }

    private func tearDownLobbiesListener() {
        lobbiesRef?.removeAllObservers()
    }

    private func refreshDataSource() {
        lobbies.removeAll()
        lobbiesCollectionView.reloadData()
    }

    private func moveToLobby(listing: LobbyListing?) {
        self.performSegue(
            withIdentifier: SegueIdentifier.lobbiesToLobby,
            sender: listing
        )
    }

    private func moveToAchievements() {
        self.performSegue(
            withIdentifier: SegueIdentifier.lobbiesToAchievements,
            sender: nil
        )
    }

    private func moveToLogin() {
        guard !AuthService().isLoggedIn() else {
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard
            let dest = segue.destination as? LobbyViewController,
            let listing = sender as? LobbyListing
        else {
            return
        }

        dest.activeListing = listing
    }
}

extension LobbiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listing = lobbies[indexPath.item]

        if listing.occupancy < listing.config.maximumPlayers && listing.isOpen {
            moveToLobby(listing: listing)
        }
    }
}

extension LobbiesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lobbies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LobbyConstants.cellReuseIdentifier,
            for: indexPath
        )

        guard let lobbyCell = cell as? LobbyCell else {
            return cell
        }

        let occupancy = lobbies[indexPath.item].occupancy
        let name = lobbies[indexPath.item].lobbyName
        let mode = lobbies[indexPath.item].config
        let isOpen = lobbies[indexPath.item].isOpen

        lobbyCell.setRoomName(name: name)
        lobbyCell.setSelectedGameMode(config: mode)
        lobbyCell.setOccupancy(num: occupancy, config: mode)

        if occupancy < mode.maximumPlayers && isOpen {
            lobbyCell.setBackground(color: .systemGreen)
        } else {
            lobbyCell.setBackground(color: .systemGray)
        }

        return lobbyCell
    }
}
