//
//  ContentView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
    @State private var count = 0

    @State private var timerLeft = 10
    @State private var isTimerRunning = false

    @State private var goToGameover = false

    @State private var buttonSize: CGFloat = 200

    @State private var xPosition: CGFloat = 200
    @State private var yPosition: CGFloat = 350

    @State private var fontSize: CGFloat = 30
    
    @State private var unlockedProvince: SriLankaProvince?

    @State private var game = 30

    @State var locationManager = LocationManager.shared

    @State private var cancellable: Cancellable?

    @Binding var showGame: Bool

    @AppStorage("TapGameHighScore") private var highScore: Int = 0

    @State private var currentTarget: targetType = .red

    @State private var tickCount = 0

    @State private var audioPlayer: AVAudioPlayer?

    @State private var playAreaWidth: CGFloat = 300
    @State private var playAreaHeight: CGFloat = 400

    enum targetType {
        case red
        case yellow
        case bomb
    }

    enum GameState {
        case playing
        case gameOver
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
//            Image("Bg-tapImage")
//            .resizable()
//            .scaledToFill()
//            .ignoresSafeArea()
            
            

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    metricCapsule(label: "Score", value: "\(count)")
                    Spacer()
                    metricCapsule(label: "High Score", value: "\(highScore)")
                }
                .padding(.horizontal)
                .padding(.top, 12)

                GeometryReader { geo in
                    Button {
                        if timerLeft <= 10 && timerLeft > 0 {
                            switch currentTarget {
                            case .red:
                                count += 1
                                print("red is being tapped")
                                playSound(named: "points")

                            case .yellow:
                                count += 5
                                print("Yellow is being tapped")
                                playSound(named: "bonus")

                            case .bomb:
                                count -= 10
                                print("bomb is being tapped")
                                playSound(named: "bomb")
                                if count < 5 {
                                    count = 0
                                }
                            }
                        }

                        if timerLeft == 10 {
                            isTimerRunning = true
                        }
                    } label: {
                        switch currentTarget {
                        case .red:
                            targetButton(
                                text: "Tap me!",
                                background: Color.red.opacity(0.85),
                                foreground: .white
                            )

                        case .yellow:
                            targetButton(
                                text: "Bonus!",
                                background: Color.yellow.opacity(0.9),
                                foreground: .primary
                            )

                        case .bomb:
                            Image("bomb-4")
                                .resizable()
                                .scaledToFit()
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                                .sensoryFeedback(.success, trigger: currentTarget)
                        }
                    }
                    .position(
                        x: min(max(xPosition, buttonSize / 2), geo.size.width - buttonSize / 2),
                        y: min(max(yPosition, buttonSize / 2), geo.size.height - buttonSize / 2)
                    )
                    .onAppear {
                        playAreaWidth = geo.size.width
                        playAreaHeight = geo.size.height
                        xPosition = geo.size.width / 2
                        yPosition = geo.size.height / 2
                    }
                    .onChange(of: geo.size) { _, newSize in
                        playAreaWidth = newSize.width
                        playAreaHeight = newSize.height
                    }
                }

                timerCapsule
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onReceive(timer) { _ in
            if isTimerRunning && timerLeft > 0 {
                timerLeft -= 1
                tickCount += 1

                if tickCount % 1 == 0 {
                    generateTarget()
                    moveTarget()
                }

                fontSize -= 1.5

                withAnimation(.easeInOut(duration: 0.9)) {
                    buttonSize -= 15
                }
            } else if timerLeft == 0 && !goToGameover {
                endGame()
                goToGameover = true
                isTimerRunning = false
                if count > highScore {
                    highScore = count
                }
                stopTimer()
            }
        }
        .navigationDestination(isPresented: $goToGameover) {
            GameOverView(
                score: count,
                gameMode: .tapFrenzy,
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

    private func metricCapsule(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }

    private var timerCapsule: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            Text("\(timerLeft)s")
                .font(.system(.title3, design: .rounded))
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

    private func targetButton(text: String, background: Color, foreground: Color) -> some View {
        Text(text)
            .font(.system(size: fontSize, design: .rounded))
            .fontWeight(.bold)
            .frame(width: buttonSize, height: buttonSize)
            .background(background)
            .foregroundColor(foreground)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }

    func resetGame() {
        print("Resetting game")
        stopTimer()
        count = 0
        timerLeft = 10
        isTimerRunning = false
        buttonSize = 200
        xPosition = playAreaWidth / 2
        yPosition = playAreaHeight / 2
        fontSize = 30
        currentTarget = .red
    }

    func moveTarget() {
        let halfSize = buttonSize / 2
        let minX = halfSize + 20
        let maxX = max(minX, playAreaWidth - halfSize - 20)
        let minY = halfSize + 20
        let maxY = max(minY, playAreaHeight - halfSize - 20)

        withAnimation(.easeInOut(duration: 0.5)) {
            xPosition = CGFloat.random(in: minX...maxX)
            yPosition = CGFloat.random(in: minY...maxY)
        }
    }

    func generateTarget() {
        let targets: [targetType] = [
            .red,
            .red,
            .red,
            .yellow,
            .bomb
        ]

        currentTarget = targets.randomElement()!
    }

    func startTimer() {
        // Using autoconnect on the timer; nothing needed here for now.
    }

    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }

    func playSound(named SoundName: String) {
        guard let url = Bundle.main.url(forResource: SoundName, withExtension: "mp3") else {
            print("Sound not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("error playing sound : \(error)")
        }
    }

    func endGame() {
        let session = GameSessionModel(
            mode: .tapFrenzy,
            score: count,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
        let result  = ProvinceExplorerManager.shared.newlyUnlockedProvince
        
        unlockedProvince = result

    }

    func finishGame() {
        let session = GameSessionModel(
            id: UUID(),
            mode: .tapFrenzy,
            score: count,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
        let result = ProvinceExplorerManager.shared.newlyUnlockedProvince
        
        unlockedProvince = result

    }
}

#Preview {
    ContentView(showGame: .constant(true))
}
