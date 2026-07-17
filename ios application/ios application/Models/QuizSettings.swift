//
//  QuizSettings.swift
//  ios application
//
//  Created by student5 on 2026-07-11.
//

import Foundation

struct QuizSettings{
    
    var amount : Int = 10
    
    var difficulty : Difficulty = .easy
    
    var category : QuizCategory = .generalKnowledge
    
    var timeLimit: Int = 60
}

enum Difficulty: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    
    var id: String {
        rawValue
    }
    
    var title: String {
        rawValue.capitalized
    }
}

enum QuizCategory: Int, CaseIterable, Identifiable {

    case generalKnowledge = 9
    case books = 10
    case film = 11
    case music = 12
    case science = 17
    case computers = 18
    case mathematics = 19
    case sports = 21
    case geography = 22
    case history = 23

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .generalKnowledge:
            return "General Knowledge"
        case .books:
            return "Books"
        case .film:
            return "Film"
        case .music:
            return "Music"
        case .science:
            return "Science"
        case .computers:
            return "Computers"
        case .mathematics:
            return "Mathematics"
        case .sports:
            return "Sports"
        case .geography:
            return "Geography"
        case .history:
            return "History"
        }
    }
}
