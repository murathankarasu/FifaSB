import SwiftUI

struct PlayerListView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var selectedPlayer: Player?
    @State private var isButtonPressed = false  // Buton basılınca renk değişimi için

    var body: some View {
        VStack {
            // Üstte "FifaSB" Başlığı
            Text("FifaSB")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.top, 20)

            HStack {
                // Sol Taraf: Arama Alanı ve Oyuncu Listesi
                VStack(alignment: .leading) {
                    TextField("Oyuncu Ara", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 250)

                    if !viewModel.searchText.isEmpty {
                        List(viewModel.filteredPlayers) { player in
                            HStack {
                                Text(player.name)
                                    .foregroundColor(.white)

                                Spacer()

                                Button(action: { viewModel.addPlayerToSelection(player: player) }) {
                                    Text("Ekle")
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                        .frame(width: 250, height: 400)
                    }
                }
                
                Spacer()

                // Sağ Taraf: Seçilen Oyuncular Listesi
                VStack(alignment: .leading) {
                    Text("Seçilen Oyuncular")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)

                    List(viewModel.selectedPlayers) { player in
                        HStack {
                            Text(player.name)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    selectedPlayer = player
                                }

                            Spacer()

                            Button(action: { removePlayer(player) }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                    .frame(width: 250, height: 400)
                }
            }
            .padding()

            Spacer()

            // Dizilişe Yerleştir Butonu
            Button(action: {
                isButtonPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isButtonPressed = false
                    viewModel.navigateToFormationScreen = true
                }
            }) {
                Text("Dizilişe Yerleştir")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isButtonPressed ? Color.green.opacity(0.6) : Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $viewModel.navigateToFormationScreen) {
                FormationView(players: viewModel.selectedPlayers)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(item: $selectedPlayer) { player in
            PlayerDetailView(player: player)
        }
    }

    /// Seçilen oyuncular listesinden oyuncu çıkarmak için fonksiyon
    private func removePlayer(_ player: Player) {
        viewModel.selectedPlayers.removeAll { $0.id == player.id }
    }
}

