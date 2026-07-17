//
//  DailyChallenge.swift
//  ios application
//
//  Created by Student 3 on 2026-07-08.
//

import Foundation


struct DailyChallengeModel: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let avaialableHour : Int
    let targetMode: GameMode
    let dateCreated: Date
    
    var completed: Bool 
}
