import Foundation

typealias Matches = [Match]

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
    
    var fullSerieName: String {
        guard !serie.name.isEmpty else {
            return league.name
        }
        
        return "\(league.name) - \(serie.name)"
    }
}

struct League: Codable {
    let imageURL: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case name
    }
}

struct OpponentElement: Codable {
    let opponent: Opponent
}

struct Opponent: Codable {
    let id: Int
    let imageURL: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
    }
}

struct Serie: Codable {
    let name: String
}
