//
//  PlayerListView.swift
//  FifaSB
//
//  Created by Murathan Karasu on 12.02.2025.
//
import SwiftUI

struct PlayerListView: View {
    @State private var players: [Player] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            List(players) { player in
                HStack {
                    AsyncImage(url: URL(string: player.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(player.name)
                            .font(.headline)
                        Text("\(player.position) - \(player.overall) OVR")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("FIFA Oyuncuları")
            .onAppear {
                fetchPlayers()
            }
        }
    }

    private func fetchPlayers() {
        APIService.shared.fetchPlayers { result in
            switch result {
            case .success(let players):
                self.players = players
                self.isLoading = false
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
