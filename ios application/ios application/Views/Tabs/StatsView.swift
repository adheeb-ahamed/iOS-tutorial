//
//  StatView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import SwiftUI
import Charts

enum StatsSection: String, CaseIterable{
    case summary = "Summary"
    case leaderboard = "Leaderboard"
}

struct StatsView: View {

    @StateObject private var vm = StatViewModel()

    @ObservedObject var manager: GameSessionManager
    
    // Two view for selection
    @State private var selectedSection: StatsSection = .summary
    
    @State private var selectedGame: GameMode = .tapFrenzy

    var body: some View {
        
        ZStack{
            
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
                    
                    headerSection
                    
                    sectionPicker
                        .padding(.horizontal)
                    
                    
                    if selectedSection == .summary {
                        SummarySection
                    } else {
                        leaderboardSection
                    }
                    
                    Spacer(minLength: 40)
                    
                }
                .padding(.top, 8)
            }
//            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                print("Stats loaded:", manager.sessions.count)
                vm.calculateStats(from: manager.sessions)
            }
            .onChange(of: manager.sessions.count) {
                vm.calculateStats(from: manager.sessions)
            }
            
        }
    }
    
    //Here leaderboard and summary section is created
    private var sectionPicker: some View {

        Picker("Statistics Section", selection: $selectedSection) {

            ForEach(StatsSection.allCases, id: \.self) { section in
                Text(section.rawValue)
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
    }
    
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Game Statistics")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.primary)

            Text("Track your progress across all games")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 4)
    }

    private var emptyStateCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.xaxis")
                .font(.largeTitle)
                .foregroundColor(.secondary)

            Text("No games played yet")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.primary)

            Text("Play a game from the Home tab to start tracking your stats.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }

    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal)

            ForEach(manager.sessions.sorted { $0.timestamp > $1.timestamp }) { session in
                SessionCard(session: session)
                    .padding(.horizontal)
            }
        }
    }
    
    private var SummarySection: some View {
        
        VStack (spacing: 20){
            
            HStack(spacing: 14) {
                MetricCard(
                    title: "Total Games",
                    value: "\(vm.totalGames)"
                )

                MetricCard(
                    title: "Highest Score",
                    value: "\(vm.highestScore)"
                )
            }
            .padding(.horizontal)

            chartSection
                .padding(.horizontal)

            if manager.sessions.isEmpty {
                emptyStateCard
                    .padding(.horizontal)
            } else {
                recentSessionsSection
            }
            
        }
    }
    
    private var selectedGameSession : [GameSessionModel]{
        
        manager.sessions.filter {
            $0.mode == selectedGame
        }
    }
    
    //Take top 10 highscores
    private var topScores : [GameSessionModel]{
        
        selectedGameSession
        
            .sorted{
                if $0.score == $1.score {
                    return $0.timestamp > $1.timestamp
                }
                
                return $0.score > $1.score
            }
        
            .prefix (10)
            .map {$0}
    }
    
    private var selectedHighestScore: Int {
        
        selectedGameSession
            .map { $0.score }
            .max() ?? 0
    }
    
    private var latestScore: Int {
        
        selectedGameSession
            .sorted { $0.timestamp > $1.timestamp }
            .first?
            .score ?? 0
    }
    
    
    private var leaderboardSection : some View {
        
        VStack (spacing : 20){
            
            gamePicker
                .padding(.horizontal)
            
            personalBestCard
                .padding(.horizontal)
            
            leaderboardMetrics
                .padding(.horizontal)
            
            topScoresSection
        }
    }
    
    
    private var gamePicker: some View {
        
        Picker("Game", selection: $selectedGame){
            
            ForEach(GameMode.allCases, id: \.self){ game in
                Text(game.displayName)
                    .tag(game)
                    
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var personalBestCard: some View {

        VStack(spacing: 10) {

            Image(systemName: "trophy.fill")
                .font(.system(size: 36))
                .foregroundStyle(.yellow)

            Text(selectedGame.displayName)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.secondary)

            Text("Personal Best")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            Text("\(selectedHighestScore)")
                .font(
                    .system(
                        size: 52,
                        weight: .black,
                        design: .rounded
                    )
                )
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(cardBackground)
    }
    
    private var leaderboardMetrics: some View {

        HStack(spacing: 14) {

            MetricCard(
                title: "Games Played",
                value: "\(selectedGameSession.count)"
            )

            MetricCard(
                title: "Latest Score",
                value: "\(latestScore)"
            )
        }
    }
    
    private var topScoresSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Top Scores")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal)

            if topScores.isEmpty {

                leaderboardEmptyState
                    .padding(.horizontal)

            } else {

                ForEach(
                    Array(topScores.enumerated()),
                    id: \.element.id
                ) { index, session in

                    LeaderboardScoreCard(
                        rank: index + 1,
                        session: session
                    )
                    .padding(.horizontal)
                }
            }
        }
    }
    
    
    private var leaderboardEmptyState: some View {

        VStack(spacing: 12) {

            Image(systemName: "trophy")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No scores yet")
                .font(.system(.headline, design: .rounded))

            Text(
                "Play \(selectedGame.displayName) to create your first leaderboard score."
            )
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(cardBackground)
    }
    
    
    struct LeaderboardScoreCard: View {

        let rank: Int
        let session: GameSessionModel

        var body: some View {

            HStack(spacing: 14) {

                rankBadge

                VStack(alignment: .leading, spacing: 4) {

                    Text(rankTitle)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)

                    Text(
                        session.timestamp.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {

                    Text("\(session.score)")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)

                    Text("points")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        Color(
                            uiColor: .secondarySystemGroupedBackground
                        )
                    )
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        rank <= 3
                            ? rankColor.opacity(0.7)
                            : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }

        private var rankBadge: some View {

            ZStack {

                Circle()
                    .fill(rankColor.opacity(0.18))
                    .frame(width: 48, height: 48)

                if rank <= 3 {

                    Image(systemName: "medal.fill")
                        .font(.title3)
                        .foregroundStyle(rankColor)

                } else {

                    Text("\(rank)")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                }
            }
        }

        private var rankTitle: String {

            switch rank {

            case 1:
                return "Personal Best"

            case 2:
                return "Second Best"

            case 3:
                return "Third Best"

            default:
                return "Rank \(rank)"
            }
        }

        private var rankColor: Color {

            switch rank {

            case 1:
                return .yellow

            case 2:
                return .gray

            case 3:
                return .orange

            default:
                return session.mode.color
            }
        }
    }
    
} //End of StatsView

extension StatsView {
    var chartSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("High Score By Game")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            if vm.stats.isEmpty {
                Text("No data to display yet")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else {
                Chart(vm.stats) { item in
                    BarMark(
                        x: .value("Game", item.mode.rawValue),
                        y: .value("Score", item.highscore)
                    )
                    .foregroundStyle(item.mode.color.opacity(0.75))
                    .cornerRadius(6)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 220)
            }
        }
        .padding(20)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(uiColor: .secondarySystemGroupedBackground))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

struct MetricCard: View {

    var title: String
    var value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
}

struct SessionCard: View {

    let session: GameSessionModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(session.mode.rawValue)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                Circle()
                    .fill(session.mode.color.opacity(0.75))
                    .frame(width: 12, height: 12)
            }

            Divider()

            sessionRow(label: "Score", value: "\(session.score)", bold: true)
            sessionRow(
                label: "Last Played",
                value: session.timestamp.formatted(.relative(presentation: .named))
            )
            sessionRow(
                label: "Date",
                value: session.timestamp.formatted(date: .abbreviated, time: .shortened)
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }

    private func sessionRow(label: String, value: String, bold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(bold ? .bold : .regular)
                .foregroundColor(.primary)
        }
    }
    
    
    
}

extension GameMode {

    var displayName: String {

        switch self {

        case .tapFrenzy:
            return "Tap Frenzy"

        case .lightItUp:
            return "Light It Up"

        case .quizRush:
            return "Quiz Rush"
        }
    }
}

//#Preview {
//    StatsView(manager: GameSessionManager)
//}

