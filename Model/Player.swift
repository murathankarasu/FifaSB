//
//  Player.swift
//  FifaSB
//
//  Created by Murathan Karasu on 12.02.2025.
//
import Foundation

struct Player: Identifiable, Codable {
    let id: Int
    let name: String
    let overall: Int
    let position: String
    let club: String?
    let nationality: String?
    
    var imageUrl: String {
        return "https://fifaindex.com/static/FIFA24/players/\(id).png"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overall
        case position
        case club = "club_name"
        case nationality = "nation_name"
    }
}
