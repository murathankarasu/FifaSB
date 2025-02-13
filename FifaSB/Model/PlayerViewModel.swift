import Foundation

class PlayerViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var searchText: String = ""
    @Published var selectedPlayers: [Player] = []

    init() {
        loadCSV()
    }

    func normalizeText(_ text: String) -> String {
        let mappings: [String: String] = ["Ğ": "G", "ğ": "g", "İ": "I", "ı": "i", "Ü": "U", "ü": "u", "Ş": "S", "ş": "s", "Ö": "O", "ö": "o", "Ç": "C", "ç": "c"]
        var normalizedText = text
        for (original, replacement) in mappings {
            normalizedText = normalizedText.replacingOccurrences(of: original, with: replacement)
        }
        return normalizedText
    }

    func loadCSV() {
        guard let path = Bundle.main.path(forResource: "player_stats", ofType: "csv") else { return }

        do {
            let data = try String(contentsOfFile: path, encoding: .isoLatin1)
            let rows = data.components(separatedBy: "\n")
            for row in rows.dropFirst() {
                let columns = row.components(separatedBy: ",")
                if columns.count > 6 {
                    let player = Player(
                        name: normalizeText(columns[0]),
                        country: normalizeText(columns[1]),
                        club: normalizeText(columns[5]),
                        age: Int(columns[4]) ?? 0,
                        value: columns[40],
                        rating: Int(columns[7]) ?? 0,
                        imageUrl: columns[50] // Oyuncu fotoğrafı URL'si CSV'nin 50. sütununda varsayıldı.
                    )
                    players.append(player)
                }
            }
        } catch {
            print("CSV okunurken hata oluştu: \(error)")
        }
    }

    var filteredPlayers: [Player] {
        if searchText.isEmpty {
            return []
        } else {
            return players.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    func addPlayerToSelection(player: Player) {
        if !selectedPlayers.contains(where: { $0.id == player.id }) {
            selectedPlayers.append(player)
        }
    }
}

