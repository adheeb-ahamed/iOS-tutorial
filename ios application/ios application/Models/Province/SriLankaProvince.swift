import Foundation

enum SriLankaProvince: String, CaseIterable, Codable, Identifiable, Hashable {
    case western = "Western"
    case central = "Central"
    case southern = "Southern"
    case northern = "Northern"
    case eastern = "Eastern"
    case northWestern = "North Western"
    case northCentral = "North Central"
    case uva = "Uva"
    case sabaragamuwa = "Sabaragamuwa"

    var id: String {
        rawValue
    }

    static func from(name: String) -> SriLankaProvince? {
        let normalizedName = name
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "province", with: "")
            .split(separator: " ")
            .joined(separator: " ")

        switch normalizedName {
        case "western":
            return .western

        case "central":
            return .central

        case "southern":
            return .southern

        case "northern":
            return .northern

        case "eastern":
            return .eastern

        case "north western", "northwestern":
            return .northWestern

        case "north central", "northcentral":
            return .northCentral

        case "uva":
            return .uva

        case "sabaragamuwa":
            return .sabaragamuwa

        default:
            print("Unknown province name: \(name)")
            return nil
        }
    }
}
