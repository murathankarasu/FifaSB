import SwiftUI

struct FormationView: View {
    var players: [Player]
    @State private var selectedFormation = "4-3-3"
    let formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"]
    
    /// Seçilen formasyona göre oyuncu dizilimini belirler
    private func getFormationPositions() -> [[Int]] {
        switch selectedFormation {
        case "4-3-3":
            return [[1], [2, 3], [4, 5, 6], [7, 8, 9], [10, 11]]
        case "4-4-2":
            return [[1], [2, 3], [4, 5, 6, 7], [8, 9], [10, 11]]
        case "3-5-2":
            return [[1], [2, 3, 4], [5, 6, 7, 8, 9], [10, 11]]
        case "5-3-2":
            return [[1], [2, 3, 4, 5, 6], [7, 8, 9], [10, 11]]
        default:
            return [[1], [2, 3, 4, 5], [6, 7, 8, 9, 10], [11]]
        }
    }

    var body: some View {
        VStack {
            Text("Formasyon Seç")
                .font(.title)
                .foregroundColor(.green)
                .padding()

            Picker("Formasyon", selection: $selectedFormation) {
                ForEach(formations, id: \.self) { formation in
                    Text(formation).tag(formation)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Text("Seçilen Formasyon: \(selectedFormation)")
                .foregroundColor(.green)
                .padding()

            // Dinamik olarak formasyon yerleşimini oluştur
            VStack {
                ForEach(getFormationPositions(), id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { index in
                            PlayerPositionView(player: players[safe: index - 1])
                        }
                    }
                }
            }
            .padding(.top, 20)

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

/// Oyuncu pozisyonu için bir daire ve isim gösteren UI bileşeni
struct PlayerPositionView: View {
    var player: Player?

    var body: some View {
        VStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.green)

            if let player = player {
                Text(player.name)
                    .font(.footnote)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            } else {
                Text("Boş")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: 80)
    }
}

// Array'de index out of bounds hatasını önlemek için güvenli erişim
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

