//
//  BlinkViewModel.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import Combine

@MainActor
final class BlinkGameViewModel: ObservableObject {

    // MARK: - Published game state

    @Published private(set) var score: Int = 0
    @Published private(set) var level: Int = 1
    @Published private(set) var hearts: Int = 3
    @Published private(set) var timerLeft: Int = 60

    @Published private(set) var cards: [BlinkCard] = [
        BlinkCard(),
        BlinkCard(),
        BlinkCard()
    ]

    @Published var goToGameOver: Bool = false
    @Published private(set) var unlockedProvince: SriLankaProvince?

    // MARK: - Dependencies

    private let soundManager: BlinkSoundManager
    private let locationManager: LocationManager
    private let sessionManager: GameSessionManager
    private let userDefaults: UserDefaults

    // MARK: - Private state

    private var timerCancellable: AnyCancellable?
    private var isTimerRunning = false
    private var hasEndedGame = false

    private var lastSecondUpdate = Date()
    private var lastLightUpdate = Date()

    // MARK: - Constants

    private let gameDuration = 60
    private let highScoreKey = "lightItUpHighScore"

    // MARK: - Initializer

    init(
        soundManager: BlinkSoundManager = .shared,
        locationManager: LocationManager = .shared,
        sessionManager: GameSessionManager = .shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.soundManager = soundManager
        self.locationManager = locationManager
        self.sessionManager = sessionManager
        self.userDefaults = userDefaults
    }

    // MARK: - Computed properties

    var highScore: Int {
        userDefaults.integer(forKey: highScoreKey)
    }

    var elapsedTime: Int {
        gameDuration - timerLeft
    }

    var lightInterval: TimeInterval {
        switch level {
        case 1:
            return 1.5
        case 2:
            return 1.2
        case 3:
            return 1.0
        case 4:
            return 0.8
        default:
            return 1.5
        }
    }

    // MARK: - Game lifecycle

    func startGame() {
        guard !isTimerRunning else {
            return
        }

        locationManager.requestPermission()
        soundManager.playBackgroundMusic()

        isTimerRunning = true
        lastSecondUpdate = Date()
        lastLightUpdate = Date()

        startTimer()
    }

    func pauseGame() {
        isTimerRunning = false
        stopTimer()
        soundManager.stopBackgroundMusic()
    }

    func resetGame() {
        stopTimer()
        soundManager.stopBackgroundMusic()

        score = 0
        level = 1
        hearts = 3
        timerLeft = gameDuration

        hasEndedGame = false
        isTimerRunning = false
        goToGameOver = false
        unlockedProvince = nil

        setupCards(for: level)

        lastSecondUpdate = Date()
        lastLightUpdate = Date()

        startGame()
    }

    // MARK: - Player actions

    func selectCard(_ card: BlinkCard) {
        guard isTimerRunning else {
            return
        }

        if card.isLit {
            handleCorrectCard()
        } else {
            handleWrongCard()
        }
    }

    private func handleCorrectCard() {
        soundManager.playSoundEffect(named: "points")
        score += 1
    }

    private func handleWrongCard() {
        soundManager.playSoundEffect(named: "wrong")

        hearts = max(hearts - 1, 0)
        score = max(score - 3, 0)

        if hearts == 0 {
            finishGame()
        }
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()

        /*
         A short interval lets lighting work accurately at
         1.5, 1.2, 1.0 and 0.8 second intervals.
         */
        timerCancellable = Timer
            .publish(
                every: 0.1,
                on: .main,
                in: .common
            )
            .autoconnect()
            .sink { [weak self] currentDate in
                self?.handleTimerUpdate(currentDate)
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func handleTimerUpdate(_ currentDate: Date) {
        guard isTimerRunning else {
            return
        }

        updateCountdown(using: currentDate)
        updateLighting(using: currentDate)
    }

    private func updateCountdown(using currentDate: Date) {
        guard currentDate.timeIntervalSince(lastSecondUpdate) >= 1 else {
            return
        }

        lastSecondUpdate = currentDate
        timerLeft -= 1

        updateLevel()

        if timerLeft <= 0 {
            timerLeft = 0
            finishGame()
        }
    }

    // MARK: - Level management

    private func updateLevel() {
        let newLevel: Int

        switch elapsedTime {
        case 0..<15:
            newLevel = 1

        case 15..<30:
            newLevel = 2

        case 30..<45:
            newLevel = 3

        default:
            newLevel = 4
        }

        guard newLevel != level else {
            return
        }

        level = newLevel
        setupCards(for: newLevel)
    }

    private func setupCards(for newLevel: Int) {
        let cardCount: Int

        switch newLevel {
        case 1:
            cardCount = 3
        case 2:
            cardCount = 4
        case 3:
            cardCount = 6
        case 4:
            cardCount = 9
        default:
            cardCount = 3
        }

        cards = (0..<cardCount).map { _ in
            BlinkCard()
        }

        lastLightUpdate = Date()
    }

    // MARK: - Lighting

    private func updateLighting(using currentDate: Date) {
        guard currentDate.timeIntervalSince(lastLightUpdate)
                >= lightInterval else {
            return
        }

        lastLightUpdate = currentDate

        for index in cards.indices {
            cards[index].isLit = false
        }

        let numberOfLitCards = level == 4 ? 2 : 1

        let selectedIndexes = cards.indices
            .shuffled()
            .prefix(numberOfLitCards)

        for index in selectedIndexes {
            cards[index].isLit = true
        }
    }

    // MARK: - Game ending

    private func finishGame() {
        guard !hasEndedGame else {
            return
        }

        hasEndedGame = true
        isTimerRunning = false

        stopTimer()
        soundManager.stopBackgroundMusic()
        updateHighScore()
        saveGameSession()

        goToGameOver = true
    }

    private func updateHighScore() {
        guard score > highScore else {
            return
        }

        userDefaults.set(score, forKey: highScoreKey)

        /*
         highScore is computed rather than @Published.
         This forces the view to refresh after UserDefaults changes.
         */
        objectWillChange.send()
    }

    private func saveGameSession() {
        let session = GameSessionModel(
            mode: .lightItUp,
            score: score,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )

        unlockedProvince = sessionManager.saveSessions(session)

        print(
            "Light It Up unlocked province:",
            unlockedProvince?.rawValue ?? "nil"
        )
    }
}
