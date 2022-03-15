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

    @IBAction private func createNewLobby(_ sender: Any) {
        guard let userId = AuthService().getUserId() else {
            fatalError("User is expected to be logged in.")
        }

        let lobbyManager = LobbyManager()
        lobbyManager.createNewLobby(userId: userId)
    }

    private func setUpLobbiesListener() {
        lobbiesRef = Database.database().reference(withPath: LobbyKeys.root)

        lobbiesRef?.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? NSDictionary,
                let lobbyName = value["name"] as? String
            else {
                return
            }

            self.addLobbyListing(
                lobbyId: snapshot.key,
                lobbyName: lobbyName,
                occupancy: Int.zero
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
                newOccupancy: (value["participants"] as? NSDictionary)?.count,
                newName: value["name"] as? String
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
        let name = lobbies[indexPath.item].lobbyName

        lobbyCell.setRoomName(name: name)
        lobbyCell.setGameMode(mode: GameModes.TimeTrials)
        lobbyCell.setOccupancy(num: occupancy)

        if occupancy < LobbyConstants.MaxSupportedPlayers {
            lobbyCell.backgroundColor = .green
        } else {
            lobbyCell.backgroundColor = .systemGray
        }

        return lobbyCell
    }
}
