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
        setUpLobbiesListener()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tearDownLobbiesListener()
        refreshDataSource()
    }

    @IBAction private func createNewLobby(_ sender: Any) {
        moveToLobby(lobbyId: nil)
    }

    private func setUpLobbiesListener() {
        lobbiesRef = Database.database().reference(withPath: LobbyKeys.root)

        lobbiesRef?.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? NSDictionary,
                let lobbyName = value[LobbyKeys.lobbyName] as? String,
                let participants = value[LobbyKeys.participants] as? NSDictionary
            else {
                return
            }

            self.addLobbyListing(
                lobbyId: snapshot.key,
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

    private func addLobbyListing(lobbyId: EntityID, lobbyName: String, occupancy: Int) {
        let newLobbyListing = LobbyListing(lobbyId: lobbyId, lobbyName: lobbyName, numPlayers: occupancy)
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
            lobbyName: newName ?? lobbies[index].lobbyName,
            numPlayers: newOccupancy ?? lobbies[index].numPlayers
        )
    }

    private func tearDownLobbiesListener() {
        lobbiesRef?.removeAllObservers()
    }

    private func refreshDataSource() {
        lobbies.removeAll()
    }

    private func moveToLobby(lobbyId: EntityID?) {
        let lobby = NetworkedLobby(lobbyId: lobbyId)

        performSegue(
            withIdentifier: LobbyConstants.lobbiesToLobbySegueIdentifier,
            sender: lobby
        )
    }
}

extension LobbiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLobby = lobbies[indexPath.item]
        moveToLobby(lobbyId: selectedLobby.lobbyId)
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
