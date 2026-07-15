//
//  BlinkGame.swift
//  ios application
//
//  Created by Student 3 on 2026-06-17.
//

import SwiftUI
import Combine

struct BlinkGame: View {

    @State private var scoreResult: Int = 0

    @State private var level: Int = 1
    
    @State private var hearts: Int = 3

    @State var locationManager = LocationManager.shared

    @State private var hasEndedGame = false

    @State private var timerLeft = 60
    @State private var isTimerRunning = true

    @State private var cards: [Card] = [
        Card(isLit: false),
        Card(isLit: false),
        Card(isLit: false)
    ]

    @State private var previousLevel: Int = 1
    
//    @State private var audioPlayer: AVAudioPlayer?

    @State private var cancellable: Cancellable?

    @State private var goToGameover = false

    @Binding var showGame: Bool

    struct Card: Identifiable {
        let id = UUID()
        var isLit: Bool
    }

    var elapsedTime: Int {
        60 - timerLeft
    }

    var lightInterval: Double {
        switch level {
        case 1: return 1.5
        case 2: return 1.2
        case 3: return 1.0
        case 4: return 0.8
        default: return 1.5
        }
    }

    @State private var lastLightUpdate: Date = .now

    @AppStorage("lightItUpHighScore") private var highScore: Int = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            

            VStack(spacing: 20) {
                Text("Light It Up!")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 8)

                HStack (spacing : 12) {
                    topMetricsCard
                    heartsView
                }
                .padding(.horizontal,20)

                Spacer()

                LazyVGrid(columns: columns(for: level), spacing: 12) {
                    ForEach(cards) { card in
                        Button(action: {
                            if card.isLit {

                                scoreResult += 1

                            } else {

                                withAnimation {
                                    hearts -= 1
                                }


                                if scoreResult <= 2 {
                                    scoreResult = 0
                                } else {
                                    scoreResult -= 3
                                }


                                if hearts == 0 {
                                    isTimerRunning = false
                                    endGame()

                                    if scoreResult > highScore {
                                        highScore = scoreResult
                                    }

                                    goToGameover = true
                                }
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(card.isLit ? Color.yellow.opacity(0.75) : Color.blue.opacity(0.3))
                                .frame(height: tileHeight(for: level))
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(GrowingButton())
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                timerCapsule
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            locationManager.requestPermission()
        }
        .onReceive(timer) { _ in
            guard isTimerRunning && timerLeft > 0 else {
                if timerLeft == 0 {
                    isTimerRunning = false
                    endGame()
                    stopTimer()

                    if scoreResult > highScore {
                        highScore = scoreResult
                    }

                    DispatchQueue.main.async {
                        goToGameover = true
                    }
                }
                return
            }
            timerLeft -= 1

            let newLevel: Int

            if elapsedTime < 15 {
                newLevel = 1
            } else if elapsedTime < 30 {
                newLevel = 2
            } else if elapsedTime < 45 {
                newLevel = 3
            } else {
                newLevel = 4
            }

            if newLevel != level {
                level = newLevel
                setupCards(for: level)
            }

            updateLighting()
        }
        .navigationDestination(isPresented: $goToGameover) {
            GameOverView(
                score: scoreResult,
                gameMode: .lightItUp,
                onRestart: {
                    resetGame()
                    goToGameover = false
                },
                onHome: {
                    goToGameover = false
                    showGame = false
                }
            )
        }
    }

    private var topMetricsCard: some View {
        HStack(spacing: 0) {
            metricItem(label: "Score", value: "\(scoreResult)")
            Divider().frame(height: 40)
            metricItem(label: "Level", value: "\(level)/4")
            Divider().frame(height: 40)
            metricItem(label: "Best", value: "\(highScore)")
        }
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal, 20)
    }
    
    private var heartsView: some View {

        HStack(spacing: 8) {

            ForEach(0..<3, id: \.self) { index in

                Image(systemName: index < hearts ? "heart.fill" : "heart")
                    .foregroundColor(index < hearts ? .red : .gray)
                    .font(.title2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }

    private func metricItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }

    private var timerCapsule: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            Text("\(timerLeft)s remaining")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }

    private func columns(for level: Int) -> [GridItem] {
        let count: Int
        switch level {
        case 1: count = 3
        case 2: count = 2
        case 3: count = 3
        case 4: count = 3
        default: count = 3
        }
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    private func tileHeight(for level: Int) -> CGFloat {
        switch level {
        case 1: return 100
        case 2: return 110
        case 3: return 90
        case 4: return 80
        default: return 100
        }
    }

    func setupCards(for newLevel: Int) {
        switch newLevel {
        case 1:
            cards = (0..<3).map { _ in Card(isLit: false) }

        case 2:
            cards = (0..<4).map { _ in Card(isLit: false) }

        case 3:
            cards = (0..<6).map { _ in Card(isLit: false) }

        case 4:
            cards = (0..<9).map { _ in Card(isLit: false) }

        default:
            break
        }
    }

    func resetGame() {
        scoreResult = 0
        level = 1
        isTimerRunning = true
        hasEndedGame = false
        setupCards(for: level)
        timerLeft = 60
        hearts = 3
    }

    func startTimer() {
        // Using autoconnect on the timer; nothing needed here for now.
    }

    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }

    func updateLighting() {
        let now = Date()

        if now.timeIntervalSince(lastLightUpdate) >= lightInterval {
            lastLightUpdate = now

            for i in cards.indices {
                cards[i].isLit = false
            }

            if level == 4 {
                let randomIndexes = cards.indices.shuffled().prefix(2)
                for i in randomIndexes {
                    cards[i].isLit.toggle()
                }
            } else {
                if let index = cards.indices.randomElement() {
                    cards[index].isLit.toggle()
                }
            }
        }
    }

    func endGame() {
        guard !hasEndedGame else {
            return
        }

        hasEndedGame = true

        let session = GameSessionModel(
            mode: .lightItUp,
            score: scoreResult,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
        GameSessionManager.shared.saveSessions(session)
    }

    func finishGame() {
        let session = GameSessionModel(
            id: UUID(),
            mode: .tapFrenzy,
            score: scoreResult,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
        GameSessionManager.shared.saveSessions(session)
    }
    
//    func playSound(named SoundName: String) {
//        guard let url = Bundle.main.url(forResource: SoundName, withExtension: "mp3") else {
//            print("Sound not found")
//            return
//        }
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
//        } catch {
//            print("error playing sound : \(error)")
//        }
//    }
}

#Preview {
    BlinkGame(showGame: .constant(true))
}
