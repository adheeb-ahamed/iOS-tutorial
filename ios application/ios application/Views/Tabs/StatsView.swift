//
//  StatView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import SwiftUI
import Charts

struct StatsView: View {

    @StateObject private var vm = StatViewModel()

    @ObservedObject var manager: GameSessionManager

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

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }
//            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                print("Stats loaded:", manager.sessions.count)
                vm.calculateStats(from: manager.sessions)
            }
            
        }
        
        
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
}

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

//#Preview {
//    StatsView(manager: GameSessionManager)
//}
