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
        setUpLobbiesListener()
        lobbiesCollectionView.dataSource = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tearDownLobbiesListener()
    }

    private func setUpLobbiesListener() {
        lobbiesRef = Database.database().reference(withPath: LobbyKeys.root)

        lobbiesRef?.observe(.childAdded) { snapshot in
            self.addLobbyListing(
                lobbyId: snapshot.key,
                occupancy: Int(snapshot.childrenCount)
            )

            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childRemoved) { snapshot in
            self.removeLobbyListing(lobbyId: snapshot.key)
            self.lobbiesCollectionView.reloadData()
        }

        lobbiesRef?.observe(.childChanged) { snapshot in
            self.updateLobbyListing(
                lobbyId: snapshot.key,
                newOccupancy: Int(snapshot.childrenCount)
            )
            self.lobbiesCollectionView.reloadData()
        }
    }

    private func addLobbyListing(lobbyId: EntityID, occupancy: Int) {
        let newLobbyListing = LobbyListing(lobbyId: lobbyId, numPlayers: occupancy)
        lobbies.append(newLobbyListing)
    }

    private func removeLobbyListing(lobbyId: EntityID) {
        lobbies = lobbies.filter { $0.lobbyId != lobbyId }
    }

    private func updateLobbyListing(lobbyId: EntityID, newOccupancy: Int) {
        guard let index = lobbies.firstIndex(where: { $0.lobbyId == lobbyId }) else {
            return
        }

        lobbies[index] = LobbyListing(lobbyId: lobbyId, numPlayers: newOccupancy)
    }

    private func tearDownLobbiesListener() {
        lobbiesRef?.removeAllObservers()
    }
}

extension LobbiesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(self.lobbies.count)")
        return self.lobbies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "com.cs3217.cloudjumpers.lobbycell",
            for: indexPath
        )

        guard let lobbyCell = cell as? LobbyCell else {
            return cell
        }

        let occupancy = lobbies[indexPath.item].numPlayers

        lobbyCell.setRoomName(name: "Let's go")
        lobbyCell.setGameMode(mode: "Time Trial")
        lobbyCell.setOccupancy(num: occupancy)

        if occupancy < LobbyConstants.MaxSupportedPlayers {
            lobbyCell.backgroundColor = .green
        } else {
            lobbyCell.backgroundColor = .systemGray
        }

        return lobbyCell
    }
}
