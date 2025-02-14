import Foundation

class PlayerViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var searchText: String = ""
    @Published var selectedPlayers: [Player] = []
    @Published var navigateToFormationScreen = false

    init() {
        loadCSV()
    }

    /// Özel karakterleri ASCII formatına normalize eder
    func normalizeText(_ text: String?) -> String {
        guard let text = text else { return "" } // nil kontrolü
        
        let mappings: [Character: String] = [
            "Ğ": "G", "ğ": "g", "İ": "I", "ı": "i", "Ü": "U", "ü": "u",
            "Ş": "S", "ş": "s", "Ö": "O", "ö": "o", "Ç": "C", "ç": "c",
            "Æ": "AE", "æ": "ae", "Ø": "O", "ø": "o", "Å": "A", "å": "a",
            "Ä": "A", "ä": "a"
        ]

        var normalizedText = ""
        for char in text {
            normalizedText.append(mappings[char] ?? String(char))
        }
        
        return normalizedText
    }

    /// CSV dosyasını yükleyip `players` dizisine ekler
    func loadCSV() {
        guard let path = Bundle.main.path(forResource: "player_stats", ofType: "csv") else {
            print("CSV dosyası bulunamadı.")
            return
        }

        do {
            let data = try String(contentsOfFile: path, encoding: .isoLatin1)
            let rows = data.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            
            for row in rows.dropFirst() { // İlk satır başlık olduğu için atlıyoruz
                let columns = row.components(separatedBy: ",")
                guard columns.count > 40 else { continue } // Yetersiz sütunları atla
                
                let ratings = columns[7...39].compactMap { Double($0) }
                let averageRating = ratings.isEmpty ? 0 : Int(ratings.reduce(0, +) / Double(ratings.count))

                let player = Player(
                    name: normalizeText(columns[safe: 0]),   // Oyuncu adı
                    country: normalizeText(columns[safe: 1]), // Ülke
                    club: normalizeText(columns[safe: 5]),   // Kulüp
                    age: Int(columns[safe: 4] ?? "0") ?? 0, // Yaş
                    value: columns[safe: 40] ?? "",
                    rating: averageRating,
                    imageUrl: ""
                )
                players.append(player)
            }
        } catch {
            print("CSV okunurken hata oluştu: \(error)")
        }
    }

    /// Arama metnine göre filtrelenmiş oyuncu listesi
    var filteredPlayers: [Player] {
        let query = searchText.lowercased()
        return query.isEmpty ? players : players.filter { $0.name.lowercased().contains(query) }
    }

    /// Seçili oyunculara yeni oyuncu ekler
    func addPlayerToSelection(player: Player) {
        if !selectedPlayers.contains(where: { $0.id == player.id }) {
            selectedPlayers.append(player)
        }
    }
}


