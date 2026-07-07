//This is to show the stats



//  StatViewModel.swift
//  ios application
//
//  Created by student5 on 2026-07-07.
//

import Foundation
import Combine

class StatViewModel: ObservableObject {
    
    @Published var stats: [GameStat] = []
    
    @Published var totalGames = 0
    @Published var highestScore: Int = 0
    
    @Published var sessions: [GameSessionModel] = []
    
    
    func calculateStats(from sessions : [GameSessionModel]) {
        
        
        totalGames = sessions.count
        
        highestScore = sessions
            .map { $0.score }
            .max() ?? 0
        
        let grouped = Dictionary(grouping: sessions) {
            $0.mode
        }
        
        
        stats = grouped.map{mode, games in
            
            GameStat (
                
                mode : mode,
                totalGames : games.count,
                highscore: games.map{ $0.score}.max() ?? 0
                
            )
            
        }
        .sorted {
            $0.mode.rawValue < $1.mode.rawValue
        }
        
        
        self.sessions = sessions
            .sorted{
                $0.timestamp > $1.timestamp
            }
            .prefix(5)
            .map{$0}
        
        
    }
    
}


