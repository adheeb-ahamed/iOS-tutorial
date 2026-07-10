//
//  MainView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-14.
//
import SwiftUI

struct MainView: View {
    
    // To go to Tap Game
    @State private var startTapGame = false
    
    //To go to Light it up game
    @State private var startLightItUpGame = false
    
    //To go to Quiz Rush game
    @State private var startQuizRush = false
    
    @State var locationManager = LocationManager.shared
    
    @StateObject private var challengeManager = DailyChallengeManager()
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic Game Hub Themed Background
//                Color(uiColor: .systemGroupedBackground) // Or use a tiled background Image asset
//                    .ignoresSafeArea()
                
                LinearGradient(
                        colors: [
                            Color.black.opacity(0.2),
                            Color.blue.opacity(0.7),
                            Color.cyan.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Header Title Section
                        VStack(spacing: 4) {
                            Text("Velocity Game Hub")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                            
                            Text("Simple light minded games")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // Dynamic Daily Challenge banner injection if active
                        if let challenge = challengeManager.todaysChallenge {
                            DailyChallengeBanner(challenge: challenge, manager: challengeManager) { mode in
                                switch mode {
                                case .tapFrenzy:
                                    startTapGame = true
                                case .lightItUp:
                                    startLightItUpGame = true
                                case .quizRush:
                                    startQuizRush = true
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Main Scrollable List of Game Cards
                        LazyVStack(spacing: 18) {
                            GameCardView(
                                title: "Tap Frenzy",
                                subtitle: "Tap the button & score!",
                                backgroundImageName: "TapFrenzy"
                            ) {
                                print("Tap Frenzy tapped!")
                                startTapGame = true
                            }
                            
                            GameCardView(
                                title: "Light It Up",
                                subtitle: "Light the button before it dims",
                                backgroundImageName: "lightImage"
                            ) {
                                print("Light It Up tapped!")
                                startLightItUpGame = true
                            }
                            
                            GameCardView(
                                title: "Quiz Rush",
                                subtitle: "Answer fast, earn big points!",
                                backgroundImageName: "quiz-image" // Bind your asset here
                            ) {
                                print("Quiz Rush tapped!")
                                startQuizRush = true
                            }
                        }
                        .padding(.horizontal)
                        // Padding cushion to prevent cards getting hidden by your custom Navigation/Tab Bars
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationDestination(isPresented: $startTapGame) {
                ContentView(showGame: $startTapGame)
            }
            .navigationDestination(isPresented: $startLightItUpGame) {
                BlinkGame(showGame: $startLightItUpGame)
            }
            .navigationDestination(isPresented: $startQuizRush) {
                QuizSettingsView()
            }
            .onAppear {
                locationManager.requestPermission()
                challengeManager.checkChallenge()
            }
        }
    }
}

#Preview {
    MainView()
}

