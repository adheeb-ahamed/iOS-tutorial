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
    private let challengeKey = "todaysChallengeKey"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkChallenge()
        setupSessionObservation()
    }
    
    private func setupSessionObservation() {
        GameSessionManager.shared.$sessions
            .sink { [weak self] sessions in
                self?.evaluateSessions(sessions)
            }
            .store(in: &cancellables)
    }
    
    private func evaluateSessions(_ sessions: [GameSessionModel]) {
        guard let challenge = todaysChallenge, !isCompletedToday() else { return }
        
        let today = Date()
        let calendar = Calendar.current
        let completedToday = sessions.contains { session in
            session.mode == challenge.targetMode && calendar.isDate(session.timestamp, inSameDayAs: today)
        }
        
        if completedToday {
            completeChallenge()
        }
    }
    
    func checkChallenge() {
            // 1. First check if they already finished it today
            if isCompletedToday() {
                todaysChallenge = nil
                UserDefaults.standard.removeObject(forKey: challengeKey)
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
            
            // 2. Check if we have a challenge saved for today in UserDefaults
            if let savedData = UserDefaults.standard.data(forKey: challengeKey),
               let savedChallenge = try? JSONDecoder().decode(DailyChallengeModel.self, from: savedData) {
                
                if Calendar.current.isDateInToday(savedChallenge.dateCreated) {
                    todaysChallenge = savedChallenge
                    return
                }
            }
            
            // 3. Challenge is unlocked! Set up a random one
            let randomMode = [GameMode.tapFrenzy, GameMode.lightItUp, GameMode.quizRush].randomElement() ?? .quizRush
            let title: String
            let description: String
            
            switch randomMode {
            case .tapFrenzy:
                title = "Tap Frenzy Speedrun"
                description = "Play one game of Tap Frenzy today."
            case .lightItUp:
                title = "Reflex Master"
                description = "Play one game of Light It Up today."
            case .quizRush:
                title = "Brain Trainer"
                description = "Play one game of Quiz Rush today."
            }
            
            let newChallenge = DailyChallengeModel(
                id: UUID(),
                title: title,
                description: description,
                avaialableHour: challengeHour,
                targetMode: randomMode,
                dateCreated: now,
                completed: false
            )
            
            todaysChallenge = newChallenge
            saveChallenge(newChallenge)
        }
        
        private func saveChallenge(_ challenge: DailyChallengeModel) {
            if let encoded = try? JSONEncoder().encode(challenge) {
                UserDefaults.standard.set(encoded, forKey: challengeKey)
            }
        }
        
        func completeChallenge() {
            // FIX: Store the exact timestamp of execution instead of a flat boolean flag
            UserDefaults.standard.set(Date(), forKey: completedDateKey)
            UserDefaults.standard.removeObject(forKey: challengeKey)
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
