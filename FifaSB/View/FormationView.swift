import SwiftUI

// "Boş" bir oyuncu tanımla (id'yi açıkça yazmaya gerek yok)
let EMPTY_PLAYER = Player(name: "Empty", country: "", club: "", age: 0, value: "", rating: 0, imageUrl: "")

struct FormationView: View {
    @State private var players: [Player]  // "Empty" oyuncular için Player array'ini kullanacağız
    @State private var selectedFormation = "4-3-3"
    let formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"]
    @State private var draggingIndex: Int?

    init(players: [Player]) {
        // Boş alanları "Empty" oyuncular ile doldur
        _players = State(initialValue: players + Array(repeating: EMPTY_PLAYER, count: 11 - players.count))
    }
    
    /// Seçilen formasyona göre oyuncu dizilimini belirler
    private func getFormationPositions() -> [[Int]] {
        let formationDict: [String: [[Int]]] = [
            "4-3-3": [[1], [2, 3, 4, 5], [6, 7, 8], [9, 10, 11]],
            "4-4-2": [[1], [2, 3, 4, 5], [6, 7, 8, 9], [10, 11]],
            "3-5-2": [[1], [2, 3, 4], [5, 6, 7, 8, 9], [10, 11]],
            "5-3-2": [[1], [2, 3, 4, 5, 6], [7, 8, 9], [10, 11]]
        ]
        return formationDict[selectedFormation] ?? [[1], [2, 3, 4, 5], [6, 7, 8, 9, 10], [11]]
    }

    var body: some View {
        VStack {
            Text("Formasyon Seç")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            Picker("Formasyon", selection: $selectedFormation) {
                ForEach(formations, id: \.self) { formation in
                    Text(formation).tag(formation)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.green.cornerRadius(8))
            .foregroundColor(.white)
            
            Text("Seçilen Formasyon: \(selectedFormation)")
                .foregroundColor(.white)
                .padding()

            // Dinamik olarak formasyon yerleşimini oluştur
            VStack {
                ForEach(getFormationPositions(), id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { index in
                            PlayerPositionView(
                                player: $players[index - 1],
                                index: index - 1,
                                onDrag: { startDrag(index: index - 1) },
                                onDrop: { endDrag(targetIndex: index - 1) }
                            )
                        }
                    }
                }
            }
            .padding(.top, 20)

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    /// Sürükleme başladığında çağrılır
    private func startDrag(index: Int) {
        draggingIndex = index
    }
    
    /// Oyuncuların yer değiştirmesini sağlar
    private func endDrag(targetIndex: Int) {
        guard let draggingIndex = draggingIndex else { return }
        
        // Eğer bırakılan yer "Empty" ise, oyuncu değiştir
        if players[targetIndex].name == "Empty" {
            players[targetIndex] = players[draggingIndex]  // Oyuncuyu yeni alana ekle
            players[draggingIndex] = EMPTY_PLAYER          // Eski alanı boşalt
        } else {
            players.swapAt(draggingIndex, targetIndex) // İki oyuncunun yerini değiştir
        }

        // Sürükleme durumlarını sıfırla
        self.draggingIndex = nil
    }
}

/// Oyuncu pozisyonu için bir daire ve isim gösteren UI bileşeni
struct PlayerPositionView: View {
    @Binding var player: Player
    let index: Int
    let onDrag: () -> Void
    let onDrop: () -> Void

    var body: some View {
        VStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(player.name == "Empty" ? .gray : .green)
                .overlay(
                    Text(player.name == "Empty" ? "??" : player.name.prefix(2))
                        .font(.footnote)
                        .foregroundColor(.white)
                )
                .onDrag {
                    onDrag()
                    return NSItemProvider(object: player.name as NSString)
                }
                .onDrop(of: [.text], isTargeted: nil) { _ in
                    onDrop()
                    return true
                }

            Text(player.name == "Empty" ? "Boş" : player.name)
                .font(.footnote)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 80)
    }
}

