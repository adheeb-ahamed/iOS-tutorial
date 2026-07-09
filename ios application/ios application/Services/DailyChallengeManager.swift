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
    
    private let completedDateKey = "dailyChallengeCompleted"
    
    init() {
        checkChallenge()
    }
    
    func checkChallenge() {
            // 1. First check if they already finished it today
            if isCompletedToday() {
                todaysChallenge = nil
                return
            }
            
            let now = Date()
            
            guard let releaseTime = Calendar.current.date(
                bySettingHour: challengeHour,
                minute: challengeMinute,
                second: 0,
                of: now
            ) else {
                return
            }
            
            // FIX: The challenge should only drop *after* or *at* 9:00 AM.
            // If it's earlier than 9:00 AM right now, hide it.
            if now < releaseTime {
                todaysChallenge = nil
                return
            }
            
            // Challenge is unlocked! Set it up
            todaysChallenge = DailyChallengeModel(
                id: UUID(),
                title: "Daily Quiz",
                description: "Complete one Quiz Rush game today.",
                avaialableHour: challengeHour,
                completed: false
            )
        }
        
        func completeChallenge() {
            // FIX: Store the exact timestamp of execution instead of a flat boolean flag
            UserDefaults.standard.set(Date(), forKey: completedDateKey)
            todaysChallenge = nil
        }
        
        private func isCompletedToday() -> Bool {
            // FIX: Reads the saved date correctly now
            guard let completedDate = UserDefaults.standard.object(forKey: completedDateKey) as? Date else {
                return false
            }
            return Calendar.current.isDateInToday(completedDate)
        }
    
}
