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
                let gameMode = GameMode(rawValue: gameModeString),
                let participants = value[LobbyKeys.participants] as? NSDictionary
            else {
                return
            }

            self.addLobbyListing(
                lobbyId: snapshot.key,
                hostId: hostId,
                lobbyName: lobbyName,
                gameMode: gameMode,
                occupancy: participants.count
            )

            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childRemoved) { snapshot in
            self.removeLobbyListing(lobbyId: snapshot.key)
            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childChanged) { snapshot in
            print("Changed \(snapshot)")

            guard
                let value = snapshot.value as? NSDictionary,
                let occupancy = value[LobbyKeys.participants] as? NSDictionary,
                let name = value[LobbyKeys.lobbyName] as? String,
                let hostId = value[LobbyKeys.hostId] as? NetworkID,
                let gameModeString = value[LobbyKeys.gameMode] as? String,
                let gameMode = GameMode(rawValue: gameModeString)
            else {
                return
            }

            self.updateLobbyListing(
                lobbyId: snapshot.key,
                newHostId: hostId,
                newName: name,
                newGameMode: gameMode,
                newOccupancy: occupancy.count
            )
            self.lobbiesCollectionView.reloadData()
        }
    }

    private func addLobbyListing(
        lobbyId: NetworkID,
        hostId: NetworkID,
        lobbyName: String,
        gameMode: GameMode,
        occupancy: Int
    ) {
        let newLobbyListing = LobbyListing(
            lobbyId: lobbyId,
            hostId: hostId,
            lobbyName: lobbyName,
            gameMode: gameMode,
            occupancy: occupancy
        )

        lobbies.append(newLobbyListing)
    }

    private func removeLobbyListing(lobbyId: NetworkID) {
        lobbies = lobbies.filter { $0.lobbyId != lobbyId }
    }

    private func updateLobbyListing(lobbyId: NetworkID, newHostId: NetworkID, newName: String, newGameMode: GameMode, newOccupancy: Int) {
        guard let index = lobbies.firstIndex(where: { $0.lobbyId == lobbyId }) else {
            return
        }

        lobbies[index] = LobbyListing(
            lobbyId: lobbyId,
            hostId: newHostId,
            lobbyName: newName,
            gameMode: newGameMode,
            occupancy: newOccupancy
        )
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

        if listing.occupancy < listing.gameMode.getMaxPlayer() {
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
        let mode = lobbies[indexPath.item].gameMode

        lobbyCell.setRoomName(name: name)
        lobbyCell.setGameMode(mode: mode)
        lobbyCell.setOccupancy(num: occupancy, mode: mode)

        if occupancy < mode.getMaxPlayer() {
            lobbyCell.backgroundColor = .green
        } else {
            lobbyCell.backgroundColor = .systemGray
        }

        return lobbyCell
    }
}
