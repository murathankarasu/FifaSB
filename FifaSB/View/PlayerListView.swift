import SwiftUI

struct PlayerListView: View {
    @ObservedObject var viewModel: PlayerViewModel // ✅ Dışarıdan alıyor
    @State private var selectedPlayer: Player?
    @State private var showDetail = false
    @State private var sortByRating = false

    var sortedPlayers: [Player] {
        sortByRating ? viewModel.filteredPlayers.sorted { $0.rating > $1.rating } : viewModel.filteredPlayers
    }

    var body: some View {
        VStack {
            // Arama Çubuğu
            TextField("Oyuncu Ara", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Sıralama Toggle
            Toggle("Rating'e göre sırala", isOn: $sortByRating)
                .padding()

            // Oyuncu Listesi
            if !viewModel.searchText.isEmpty {
                List(sortedPlayers) { player in
                    HStack {
                        Text("\(player.name) - Rating: \(player.rating)")
                        Spacer()
                        Button(action: {
                            viewModel.addPlayerToSelection(player: player)
                        }) {
                            Text("Ekle")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                }
            }

            // Seçilen Oyuncular Listesi
            if !viewModel.selectedPlayers.isEmpty {
                Text("Seçilen Oyuncular")
                    .font(.headline)
                    .padding()

                List(viewModel.selectedPlayers) { player in
                    HStack {
                        Text(player.name)
                            .onTapGesture {
                                selectedPlayer = player
                                showDetail = true
                            }
                    }
                }
            }

            Spacer()

            // Dizilişe Yerleştir Butonu
            Button(action: {
                $viewModel.navigateToFormationScreen = true
            }) {
                Text("Dizilişe Yerleştir")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $viewModel.navigateToFormationScreen) {
                FormationView(players: viewModel.selectedPlayers)
            }
        }
        .sheet(item: $selectedPlayer) { player in
            PlayerDetailView(player: player)
        }
    }
}

