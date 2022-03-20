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

    @IBAction private func createNewLobby(_ sender: Any) {
        guard let userId = AuthService().getUserId() else {
            return
        }
        moveToLobby(lobbyId: nil, hostId: userId)
    }

    private func setUpLobbiesListener() {
        lobbiesRef = Database.database().reference(withPath: LobbyKeys.root)

        lobbiesRef?.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? NSDictionary,
                let hostId = value[LobbyKeys.hostId] as? EntityID,
                let lobbyName = value[LobbyKeys.lobbyName] as? String,
                let participants = value[LobbyKeys.participants] as? NSDictionary
            else {
                return
            }

            self.addLobbyListing(
                lobbyId: snapshot.key,
                hostId: hostId,
                lobbyName: lobbyName,
                occupancy: participants.count
            )

            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childRemoved) { snapshot in
            self.removeLobbyListing(lobbyId: snapshot.key)
            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childChanged) { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }

            self.updateLobbyListing(
                lobbyId: snapshot.key,
                newOccupancy: (value[LobbyKeys.participants] as? NSDictionary)?.count,
                newName: value[LobbyKeys.lobbyName] as? String
            )
            self.lobbiesCollectionView.reloadData()
        }
    }

    private func addLobbyListing(lobbyId: EntityID, hostId: EntityID, lobbyName: String, occupancy: Int) {
        let newLobbyListing = LobbyListing(
            lobbyId: lobbyId,
            hostId: hostId,
            lobbyName: lobbyName,
            numPlayers: occupancy
        )

        lobbies.append(newLobbyListing)
    }

    private func removeLobbyListing(lobbyId: EntityID) {
        lobbies = lobbies.filter { $0.lobbyId != lobbyId }
    }

    private func updateLobbyListing(lobbyId: EntityID, newOccupancy: Int?, newName: String?) {
        guard let index = lobbies.firstIndex(where: { $0.lobbyId == lobbyId }) else {
            return
        }

        lobbies[index] = LobbyListing(
            lobbyId: lobbyId,
            hostId: lobbies[index].hostId,
            lobbyName: newName ?? lobbies[index].lobbyName,
            numPlayers: newOccupancy ?? lobbies[index].numPlayers
        )
    }

    private func tearDownLobbiesListener() {
        lobbiesRef?.removeAllObservers()
    }

    private func refreshDataSource() {
        lobbies.removeAll()
        lobbiesCollectionView.reloadData()
    }

    private func moveToLobby(lobbyId: EntityID?, hostId: EntityID) {
        let lobby = NetworkedLobby(lobbyId: lobbyId, hostId: hostId)

        self.performSegue(
            withIdentifier: SegueIdentifier.lobbiesToLobby,
            sender: lobby
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard
            let dest = segue.destination as? LobbyViewController,
            let lobby = sender as? NetworkedLobby
        else {
            return
        }

        lobby.setOnFinalizedCallback(callback: dest.moveToGame)
        dest.activeLobby = lobby
    }
}

extension LobbiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLobby = lobbies[indexPath.item]
        moveToLobby(lobbyId: selectedLobby.lobbyId, hostId: selectedLobby.hostId)
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

        let occupancy = lobbies[indexPath.item].numPlayers
        let name = lobbies[indexPath.item].lobbyName

        lobbyCell.setRoomName(name: name)
        lobbyCell.setGameMode(mode: GameModes.TimeTrial.rawValue)
        lobbyCell.setOccupancy(num: occupancy)

        if occupancy < LobbyConstants.MaxSupportedPlayers {
            lobbyCell.backgroundColor = .green
        } else {
            lobbyCell.backgroundColor = .systemGray
        }

        return lobbyCell
    }
}
