//

// THIS IS USED TO SEND THE DATA THAT IS TAKE FROM THE GAMES TO GAMESESSION MODEL
// ----------------------------------------------------------------------------
//
//  GameSessionManager.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import Foundation
import Combine


class GameSessionManager : ObservableObject {
    
    static let shared = GameSessionManager()
    
    @Published var sessions: [GameSessionModel] = []
    
    private let key = "savedGameSession"
    
    private init(){
        loadSessions()
    }
    
    //This is where you add session and the amount you gain once you unlock a province 
    func saveSessions(_ session: GameSessionModel) -> SriLankaProvince? {

        sessions.append(session)

        let newlyUnlockedProvince =
            ProvinceExplorerManager.shared.unlockProvince(
                latitude: session.latitude,
                longitude: session.longitude
            )
        

        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save session:", error)
        }
        
        return newlyUnlockedProvince
    }
    
    
    
    func loadSessions(){
        
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return
        }
        
        
        do {
            sessions = try JSONDecoder().decode([GameSessionModel].self, from: data)
        } catch {
            print("Failed to load the session", error)
        }
    }
    
    func clearSessions() {
        sessions.removeAll()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
//    func addSession(_ session: GameSessionModel) {
//            sessions.append(session)
//    }
    
    
    

    
}

