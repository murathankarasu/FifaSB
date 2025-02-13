import SwiftUI

struct FormationView: View {
    var players: [Player]
    @State private var selectedFormation = "4-3-3"
    let formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"]

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

            // Formasyon Görünümü
            VStack {
                HStack {
                    PlayerPositionView(player: players[safe: 0])
                    PlayerPositionView(player: players[safe: 1])
                    PlayerPositionView(player: players[safe: 2])
                }
                HStack {
                    PlayerPositionView(player: players[safe: 3])
                    PlayerPositionView(player: players[safe: 4])
                    PlayerPositionView(player: players[safe: 5])
                }
                HStack {
                    PlayerPositionView(player: players[safe: 6])
                    PlayerPositionView(player: players[safe: 7])
                }
                HStack {
                    PlayerPositionView(player: players[safe: 8])
                    PlayerPositionView(player: players[safe: 9])
                }
                HStack {
                    PlayerPositionView(player: players[safe: 10])
                }
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

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

