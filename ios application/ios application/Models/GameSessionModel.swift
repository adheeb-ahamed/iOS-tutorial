// ----------------------------------------------------------
//THIS IS FOR PROVIDING EACH GAME PLAY A SPECIFIC IDENTIFIABLE ID.


import Foundation

//Represents the different types of app we are using the gameSession for
enum GameMode: String, Codable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light it up"
    case quizRush = "Quiz Rush"
}

struct GameSessionModel: Codable, Identifiable {
    
    var id =  UUID()
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    
}
