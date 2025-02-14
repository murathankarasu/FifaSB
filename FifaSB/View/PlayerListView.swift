import SwiftUI

struct PlayerListView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var selectedPlayer: Player?
    @State private var isButtonPressed = false  // Butona basılınca renk değişimi için
    @State private var showPlayerList = false  // Oyuncu listesi animasyonu için

    var body: some View {
        VStack {
            // **Üstte "FifaSB" Başlığı**
            Text("FifaSB")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.top, 20)

            // **Arama Alanı ve Butonu**
            VStack {
                Text("Oyuncu Arama")
                    .font(.headline)
                    .foregroundColor(.green)

                TextField("Oyuncu Ara", text: $viewModel.searchText, onEditingChanged: { _ in
                    showPlayerList = true
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(width: 300)

                // **Oyuncu Listesi (Maksimum 4 oyuncu göster)**
                if showPlayerList && !viewModel.searchText.isEmpty {
                    VStack {
                        ForEach(viewModel.filteredPlayers.prefix(4)) { player in  // **Maksimum 4 oyuncu**
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
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        }
                    }
                    .frame(width: 300)
                }
            }

            Spacer()

            // **Seçilen Oyuncular Listesi (BÜYÜTÜLDÜ)**
            VStack {
                Text("Seçilen Oyuncular")
                    .font(.headline)
                    .foregroundColor(.green)

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
                .frame(maxWidth: .infinity, maxHeight: 500)  // **Liste daha büyük hale getirildi**
                .padding(.horizontal, 20)
            }

            Spacer()

            // **Dizilişe Yerleştir Butonu (SABİT BOYUTLU, GENİŞ ENLİ)**
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
                    .frame(width: 350, height: 50)  // **Sabit küçük boyut, geniş en**
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

    /// Seçilen oyuncular listesinden oyuncu çıkarır
    private func removePlayer(_ player: Player) {
        viewModel.selectedPlayers.removeAll { $0.id == player.id }
    }
}

