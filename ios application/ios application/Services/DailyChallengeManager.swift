//
//  DailyChallengeManager.swift
//  ios application
//
//  Created by Student 3 on 2026-07-08.
//

import Foundation
import Combine
import SwiftUI


class DailyChallengeManager : ObservableObject {
    
    @Published var todaysChallenge: DailyChallengeModel?
    
    @AppStorage("challengeHour") private var challengeHour = 9
    @AppStorage("challengeMinute") private var challengeMinute = 0
    
    private let completedKey = "dailyChallengeCompleted"
    
    init() {
        checkChallenge()
    }
    
    func checkChallenge() {
        
        let now = Date()
        
        guard let releaseTime = Calendar.current.date(
            bySettingHour: challengeHour,
            minute: challengeMinute,
            second: 0,
            of: now
        ) else {
            return
        }
        
        if now > releaseTime {
            todaysChallenge = nil
            return
        }
        
        todaysChallenge = DailyChallengeModel(
            id: UUID(),
            title: "Daily Quiz",
            description: "Complete one Quiz Rush game today.",
            avaialableHour: challengeHour,
            completed: false
        )
        
    }
    
    
    func completeChallenge() {
        UserDefaults.standard.set(true, forKey: completedKey)
        todaysChallenge = nil
    }
    
    
    private func isCompletedToday() -> Bool {

       guard let completedDate = UserDefaults.standard.object(forKey: completedKey) as? Date else {
           return false
       }

       return Calendar.current.isDateInToday(completedDate)
   }
    
}
