import SwiftUI

struct BlinkGame: View {

    @StateObject private var viewModel = BlinkGameViewModel()

    @Binding var showGame: Bool

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                titleSection

                HStack(spacing: 12) {
                    topMetricsCard
                    heartsView
                }
                .padding(.horizontal, 20)

                Spacer()

                gameGrid

                Spacer()

                timerCapsule
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.pauseGame()
        }
        .navigationDestination(
            isPresented: $viewModel.goToGameOver
        ) {
            GameOverView(
                score: viewModel.score,
                gameMode: .lightItUp,
                unlockedProvince: viewModel.unlockedProvince,
                onRestart: {
                    viewModel.resetGame()
                },
                onHome: {
                    viewModel.goToGameOver = false
                    showGame = false
                }
            )
        }
    }

    // MARK: - Title

    private var titleSection: some View {
        Text("Light It Up!")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.top, 8)
    }

    // MARK: - Grid

    private var gameGrid: some View {
        LazyVGrid(
            columns: columns(for: viewModel.level),
            spacing: 12
        ) {
            ForEach(viewModel.cards) { card in
                Button {
                    viewModel.selectCard(card)
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            card.isLit
                                ? Color.yellow.opacity(0.75)
                                : Color.blue.opacity(0.3)
                        )
                        .frame(
                            height: tileHeight(
                                for: viewModel.level
                            )
                        )
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                }
                .buttonStyle(GrowingButton())
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Metrics

    private var topMetricsCard: some View {
        HStack(spacing: 0) {
            metricItem(
                label: "Score",
                value: "\(viewModel.score)"
            )

            Divider()
                .frame(height: 40)

            metricItem(
                label: "Level",
                value: "\(viewModel.level)/4"
            )

            Divider()
                .frame(height: 40)

            metricItem(
                label: "Best",
                value: "\(viewModel.highScore)"
            )
        }
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color(
                        uiColor: .secondarySystemGroupedBackground
                    )
                )
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 6,
                    x: 0,
                    y: 3
                )
        )
    }

    private func metricItem(
        label: String,
        value: String
    ) -> some View {
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

    // MARK: - Hearts

    private var heartsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Image(
                    systemName: index < viewModel.hearts
                        ? "heart.fill"
                        : "heart"
                )
                .foregroundColor(
                    index < viewModel.hearts
                        ? .red
                        : .gray
                )
                .font(.title2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(
                    Color(
                        uiColor: .secondarySystemGroupedBackground
                    )
                )
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
        .animation(
            .spring(),
            value: viewModel.hearts
        )
    }

    // MARK: - Timer

    private var timerCapsule: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(
                    .system(
                        .subheadline,
                        design: .rounded
                    )
                )
                .foregroundColor(.secondary)

            Text("\(viewModel.timerLeft)s remaining")
                .font(
                    .system(
                        .headline,
                        design: .rounded
                    )
                )
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(
                    Color(
                        uiColor: .secondarySystemGroupedBackground
                    )
                )
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }

    // MARK: - Layout helpers

    private func columns(for level: Int) -> [GridItem] {
        let columnCount: Int

        switch level {
        case 1:
            columnCount = 3
        case 2:
            columnCount = 2
        case 3, 4:
            columnCount = 3
        default:
            columnCount = 3
        }

        return Array(
            repeating: GridItem(
                .flexible(),
                spacing: 12
            ),
            count: columnCount
        )
    }

    private func tileHeight(for level: Int) -> CGFloat {
        switch level {
        case 1:
            return 100
        case 2:
            return 110
        case 3:
            return 90
        case 4:
            return 80
        default:
            return 100
        }
    }
}

#Preview {
    NavigationStack {
        BlinkGame(showGame: .constant(true))
    }
}
