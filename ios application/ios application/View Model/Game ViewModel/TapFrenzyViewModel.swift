//
//  TapFrenzyViewModel.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import Combine
import CoreGraphics

@MainActor
final class TapFrenzyViewModel: ObservableObject {

    // MARK: - Published UI state

    @Published private(set) var score: Int = 0
    @Published private(set) var timerLeft: Int = 10

    @Published private(set) var buttonSize: CGFloat = 200
    @Published private(set) var fontSize: CGFloat = 30

    @Published private(set) var xPosition: CGFloat = 150
    @Published private(set) var yPosition: CGFloat = 200

    @Published private(set) var currentTarget: TapTargetType = .red

    @Published var goToGameOver: Bool = false

    @Published private(set) var unlockedProvince: SriLankaProvince?

    // MARK: - Dependencies

    private let soundManager: TapFrenzySoundManager
    private let locationManager: LocationManager
    private let sessionManager: GameSessionManager
    private let userDefaults: UserDefaults

    // MARK: - Game state

    private var timerCancellable: AnyCancellable?
    private var isTimerRunning = false
    private var hasEndedGame = false

    private var playAreaWidth: CGFloat = 300
    private var playAreaHeight: CGFloat = 400

    // MARK: - Constants

    private let gameDuration = 10
    private let initialButtonSize: CGFloat = 200
    private let initialFontSize: CGFloat = 30
    private let highScoreKey = "TapGameHighScore"

    // MARK: - Initializer

    init(
        soundManager: TapFrenzySoundManager,
        locationManager: LocationManager,
        sessionManager: GameSessionManager,
        userDefaults: UserDefaults
    ) {
        self.soundManager = soundManager
        self.locationManager = locationManager
        self.sessionManager = sessionManager
        self.userDefaults = userDefaults
    }

    convenience init() {
        self.init(
            soundManager: .shared,
            locationManager: .shared,
            sessionManager: .shared,
            userDefaults: .standard
        )
    }

    // MARK: - Computed properties

    var highScore: Int {
        userDefaults.integer(forKey: highScoreKey)
    }

    var isGameRunning: Bool {
        isTimerRunning
    }

    // MARK: - View lifecycle

    func prepareGame() {
        locationManager.requestPermission()
    }

    func stopGame() {
        stopTimer()
        soundManager.stopSound()
    }

    // MARK: - Play area

    func updatePlayArea(
        width: CGFloat,
        height: CGFloat
    ) {
        playAreaWidth = width
        playAreaHeight = height

        if !isTimerRunning {
            centerTarget()
        }
    }

    private func centerTarget() {
        xPosition = playAreaWidth / 2
        yPosition = playAreaHeight / 2
    }

    // MARK: - Player action

    func tapTarget() {
        guard timerLeft > 0 else {
            return
        }

        if !isTimerRunning {
            startGame()
        }

        switch currentTarget {
        case .red:
            score += 1
            soundManager.playSound(named: "points")

        case .yellow:
            score += 5
            soundManager.playSound(named: "bonus")

        case .bomb:
            score = max(score - 10, 0)
            soundManager.playSound(named: "bomb")
        }
    }

    // MARK: - Game lifecycle

    private func startGame() {
        guard !isTimerRunning else {
            return
        }

        isTimerRunning = true
        hasEndedGame = false

        startTimer()
    }

    func resetGame() {
        stopTimer()
        soundManager.stopSound()

        score = 0
        timerLeft = gameDuration

        buttonSize = initialButtonSize
        fontSize = initialFontSize

        currentTarget = .red

        isTimerRunning = false
        hasEndedGame = false
        goToGameOver = false
        unlockedProvince = nil

        centerTarget()
    }

    private func finishGame() {
        guard !hasEndedGame else {
            return
        }

        hasEndedGame = true
        isTimerRunning = false

        stopTimer()
        updateHighScore()
        saveGameSession()

        goToGameOver = true
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()

        timerCancellable = Timer
            .publish(
                every: 1,
                on: .main,
                in: .common
            )
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTimerTick()
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func handleTimerTick() {
        guard isTimerRunning else {
            return
        }

        guard timerLeft > 0 else {
            finishGame()
            return
        }

        timerLeft -= 1

        if timerLeft == 0 {
            finishGame()
            return
        }

        generateTarget()
        moveTarget()
        shrinkTarget()
    }

    // MARK: - Target generation

    private func generateTarget() {
        let targetOptions: [TapTargetType] = [
            .red,
            .red,
            .red,
            .yellow,
            .bomb
        ]

        currentTarget = targetOptions.randomElement() ?? .red
    }

    private func shrinkTarget() {
        buttonSize = max(buttonSize - 15, 70)
        fontSize = max(fontSize - 1.5, 14)
    }

    private func moveTarget() {
        let halfSize = buttonSize / 2
        let padding: CGFloat = 20

        let minX = halfSize + padding
        let maximumX = playAreaWidth - halfSize - padding
        let maxX = max(minX, maximumX)

        let minY = halfSize + padding
        let maximumY = playAreaHeight - halfSize - padding
        let maxY = max(minY, maximumY)

        xPosition = CGFloat.random(in: minX...maxX)
        yPosition = CGFloat.random(in: minY...maxY)
    }

    // MARK: - High score

    private func updateHighScore() {
        guard score > highScore else {
            return
        }

        userDefaults.set(score, forKey: highScoreKey)

        /*
         highScore is computed from UserDefaults, so this
         refreshes the view after the stored value changes.
         */
        objectWillChange.send()
    }

    // MARK: - Session saving

    private func saveGameSession() {
        let session = GameSessionModel(
            mode: .tapFrenzy,
            score: score,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )

        unlockedProvince = sessionManager.saveSessions(session)

        print(
            "Unlocked province:",
            unlockedProvince?.rawValue ?? "nil"
        )
    }
}
