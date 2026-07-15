// ----------------------------------------------------------
//THIS IS FOR PROVIDING EACH GAME PLAY A SPECIFIC IDENTIFIABLE ID.


import Foundation
import SwiftUI

//Represents the different types of app we are using the gameSession for
enum GameMode: String, Codable, CaseIterable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light it up"
    case quizRush = "Quiz Rush"
    
    
    //To differenciate the color for each pin I'm doing this
    var color : Color {
        switch self {
        case .tapFrenzy:
            return .red
        case .lightItUp:
            return .blue
        case .quizRush:
            return .yellow
        }
    }
}




struct GameSessionModel: Codable, Identifiable {
    
    var id =  UUID()
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    
}

