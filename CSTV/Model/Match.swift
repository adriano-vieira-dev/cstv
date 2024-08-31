// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matches = try? JSONDecoder().decode(Matches.self, from: jsonData)

import Foundation

// MARK: - Match
struct Match: Codable, Identifiable {
    let id: Int
    let beginAt: Date
    let opponents: [OpponentElement]
    let serie: Serie
    let league: League

    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case opponents, serie, league
    }
}

// MARK: - League
struct League: Codable {
    let imageURL: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case name
    }
}

// MARK: - OpponentElement
struct OpponentElement: Codable {
    let opponent: Opponent
}

// MARK: - Opponent
struct Opponent: Codable {
    let imageURL: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case name
    }
}

// MARK: - Serie
struct Serie: Codable {
    let name: String
}

typealias Matches = [Match]
