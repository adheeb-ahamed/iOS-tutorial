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
    
    
    //This is to create a circle at the top right corner
    @AppStorage("playerName") private var playerName = ""
    @AppStorage("selectedAvatar") private var selectedAvatar = "person.crop.circle.fill"
    
    @State private var showProfileSetup = false
    
    
    @ObservedObject var manager: GameSessionManager
    
    
    
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
                        
                        // Header Title and Profile Section
                        HStack(spacing: 15) {

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Velocity Game Hub")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.black)
                                    .foregroundStyle(.white)

                                Text(
                                    playerName.isEmpty
                                    ? "Simple light minded games"
                                    : "Welcome, \(playerName)"
                                )
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.75))
                            }

                            Spacer()

                            Button {
                                showProfileSetup = true
                            } label: {
                                Image(selectedAvatar)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(
                                                Color.white.opacity(0.8),
                                                lineWidth: 2
                                            )
                                    }
                                    .shadow(
                                        color: .black.opacity(0.25),
                                        radius: 5,
                                        x: 0,
                                        y: 3
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
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
            .sheet(isPresented: $showProfileSetup){
                ProfileSetupView(manager: manager)
            }
            .onAppear {
                locationManager.requestPermission()
                challengeManager.checkChallenge()
            }
        }
    }
}

#Preview {
    MainView(
        manager: GameSessionManager.shared
    )
}
