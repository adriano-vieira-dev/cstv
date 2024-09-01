import Foundation

typealias Teams = [Team]

struct Team: Codable {
    let id: Int
    let players: [Player]
}

struct Player: Codable {
    let id: Int
    let firstName: String?
    let imageURL: String?
    let lastName: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case imageURL = "image_url"
        case lastName = "last_name"
        case name
    }
}

let personNameFormatter = PersonNameComponentsFormatter()

extension Player {
    var fullName: String {
        var components = PersonNameComponents ()
        components.givenName = firstName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        components.familyName = lastName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return personNameFormatter.string(from: components)
    }
}
