//
//  GameStat.swift
//  ios application
//
//  Created by student5 on 2026-07-07.
//

import Foundation

struct GameStat: Identifiable {
    
    let id = UUID()
    
    var mode : GameMode
    var totalGames : Int
    var highscore : Int
}
