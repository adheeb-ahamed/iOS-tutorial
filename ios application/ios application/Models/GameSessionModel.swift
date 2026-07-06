//THIS IS FOR PROVIDING EACH GAME PLAY A SPECIFIC IDENTIFIABLE ID.


import Foundation

//Represents the different types of app we are using the gameSession for
enum GameMode: String, Codable {
    case tapFrenzy
    case lightItUp
    case quizRush
}

struct GameSessionModel: Codable, Identifiable {
    
    var id =  UUID()
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    
}
