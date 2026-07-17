import SwiftUI

struct GameOverView: View {
    var score: Int
    var gameMode: GameMode
    var unlockedProvince: SriLankaProvince? = nil
    var onRestart: () -> Void
    var onHome: () -> Void

    @EnvironmentObject private var coinManager: CoinManager
    @Environment(\.dismiss) private var dismiss

    @State private var hasAwardedCoins = false
    
    @State private var provinceForAlert: SriLankaProvince?
    

    private var coinsEarned: Int {
        gameMode.coinsEarned(for: score)
    }

    var shareText: String {
        """
        I scored \(score) points in \(gameMode.rawValue)!
        I also earned \(coinsEarned) coins!

        Can you beat my score?
        """
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                headerSection

                scoreCard

                coinRewardCard

                actionButtons
            }
        }
        .alert(
            "New Province Discovered!",
            isPresented: Binding(
                get: {
                    provinceForAlert != nil
                },
                set: { isPresented in
                    if !isPresented {
                        provinceForAlert = nil
                    }
                }
            ),
            presenting: provinceForAlert
        ) { _ in
            Button("Continue") {
                provinceForAlert = nil
            }
        } message: { province in
            Text(
                """
                You explored \(province.rawValue) Province.

                You earned 200 coins!
                """
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            awardCoins()
            provinceForAlert = unlockedProvince
        }
    }

    private var headerSection: some View {
        Text("Game Over")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.red.opacity(0.75))
    }

    private var scoreCard: some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(.system(size: 56, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.primary)

            Text("Final Score")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)

            Text(gameMode.rawValue)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .padding(.horizontal, 24)
    }

    private var coinRewardCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 34))
                .foregroundStyle(.yellow)

            VStack(alignment: .leading, spacing: 3) {
                Text("+\(coinsEarned) Coins")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)

                Text("Reward earned from this game")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(coinManager.balance)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)

                Text("Total")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.15))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.45), lineWidth: 1)
        }
        .padding(.horizontal, 24)
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            actionButton(
                title: "Restart",
                icon: "arrow.counterclockwise",
                action: onRestart
            )

            actionButton(
                title: "Home",
                icon: "house.fill",
                action: onHome
            )

            ShareLink(item: shareText) {
                VStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)

                    Text("Share")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
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
        }
        .padding(.horizontal, 24)
    }

    private func awardCoins() {
        guard !hasAwardedCoins else { return }

        coinManager.addCoins(amount: coinsEarned)
        hasAwardedCoins = true
    }

    private func actionButton(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
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
    }
}

#Preview {
    GameOverView(
        score: 100,
        gameMode: .tapFrenzy,
        onRestart: {
            print("Restart clicked")
        },
        onHome: {
            print("Home clicked")
        }
    )
    .environmentObject(CoinManager.shared)
}
