//
//  PlayerRank.swift
//  ios application
//
//  Created by Student 3 on 2026-07-15.
//

import SwiftUI

enum PlayerRank: String {
    case rookie = "Rookie"
    case challenger = "Challenger"
    case skilled = "Skilled"
    case elite = "Elite"
    case legend = "Legend"

    static func rank(for totalGames: Int) -> PlayerRank {
        switch totalGames {
        case 0...4:
            return .rookie

        case 5...14:
            return .challenger

        case 15...29:
            return .skilled

        case 30...49:
            return .elite

        default:
            return .legend
        }
    }

    var icon: String {
        switch self {
        case .rookie:
            return "shield.fill"

        case .challenger:
            return "bolt.fill"

        case .skilled:
            return "star.fill"

        case .elite:
            return "medal.fill"

        case .legend:
            return "crown.fill"
        }
    }

    var color: Color {
        switch self {
        case .rookie:
            return .gray

        case .challenger:
            return .green

        case .skilled:
            return .blue

        case .elite:
            return .purple

        case .legend:
            return .yellow
        }
    }

    var nextRankGameRequirement: Int? {
        switch self {
        case .rookie:
            return 5

        case .challenger:
            return 15

        case .skilled:
            return 30

        case .elite:
            return 50

        case .legend:
            return nil
        }
    }
}
