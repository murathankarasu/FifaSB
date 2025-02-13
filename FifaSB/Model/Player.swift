import Foundation

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let club: String
    let age: Int
    let value: String
    let rating: Int
    let imageUrl: String
}
