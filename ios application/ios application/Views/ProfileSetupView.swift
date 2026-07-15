import SwiftUI

struct ProfileSetupView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var manager: GameSessionManager

    @AppStorage("playerName")
    private var savedPlayerName = ""

    @AppStorage("selectedAvatar")
    private var savedAvatar = "avatarWarrior"

    @State private var playerName = ""

    @State private var selectedAvatar = "avatarWarrior"

    @State private var currentStep = 1

    private let avatars = [
        "chess",
        "car",
        "football",
        "fire",
        "ninja",
        "heart-love"
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var totalGames: Int {
        manager.sessions.count
    }

    private var currentRank: PlayerRank {
        PlayerRank.rank(for: totalGames)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.blue.opacity(0.85),
                        Color.cyan.opacity(0.45)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(
                    .vertical,
                    showsIndicators: false
                ) {
                    VStack(spacing: 25) {
                        profilePreview

                        rankSection

                        stepIndicator

                        if currentStep == 1 {
                            nameSection
                        } else {
                            avatarSection
                        }

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("Player Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
            .onAppear {
                playerName = savedPlayerName
                selectedAvatar = savedAvatar
            }
        }
    }

    private var profilePreview: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(selectedAvatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 115, height: 115)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                currentRank.color,
                                lineWidth: 4
                            )
                    }
                    .shadow(
                        color: currentRank.color.opacity(0.6),
                        radius: 12
                    )

                Image(systemName: currentRank.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                    .frame(width: 36, height: 36)
                    .background(currentRank.color)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    }
            }

            Text(
                playerName.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
                ? "Player"
                : playerName
            )
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.white)

            Text("\(totalGames) games played")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }

    private var rankSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: currentRank.icon)
                    .font(.title2)
                    .foregroundStyle(currentRank.color)

                VStack(alignment: .leading, spacing: 3) {
                    Text(currentRank.rawValue)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(rankDescription)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()
            }

            rankProgressSection
        }
        .padding()
        .background(.white.opacity(0.12))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    currentRank.color.opacity(0.7),
                    lineWidth: 1
                )
        }
    }

    @ViewBuilder
    private var rankProgressSection: some View {
        if let nextRequirement =
            currentRank.nextRankGameRequirement {

            let progress = Double(totalGames)
                / Double(nextRequirement)

            VStack(spacing: 8) {
                ProgressView(
                    value: min(progress, 1)
                )
                .tint(currentRank.color)

                HStack {
                    Text("\(totalGames) games")

                    Spacer()

                    Text(
                        "\(nextRequirement - totalGames) more to next rank"
                    )
                }
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))
            }
        } else {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)

                Text("Maximum rank achieved")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()
            }
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(.cyan)
                .frame(height: 6)

            Capsule()
                .fill(
                    currentStep == 2
                    ? Color.cyan
                    : Color.white.opacity(0.25)
                )
                .frame(height: 6)
        }
    }

    private var nameSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 7) {
                Text("Enter Your Name")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(
                    "This name will be displayed on your player profile."
                )
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            }

            TextField(
                "Player name",
                text: $playerName
            )
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .padding()
            .background(.white.opacity(0.14))
            .foregroundStyle(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .white.opacity(0.25),
                        lineWidth: 1
                    )
            }

            Button {
                currentStep = 2
            } label: {
                Text("Choose Avatar")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.cyan)
                    .foregroundStyle(.black)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
            }
            .disabled(cleanedPlayerName.isEmpty)
            .opacity(
                cleanedPlayerName.isEmpty ? 0.5 : 1
            )
        }
        .padding()
        .background(.black.opacity(0.15))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }

    private var avatarSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 7) {
                Text("Choose Your Avatar")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(
                    "Select the character that represents you."
                )
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            }

            LazyVGrid(
                columns: columns,
                spacing: 18
            ) {
                ForEach(avatars, id: \.self) { avatar in
                    avatarButton(avatar)
                }
            }

            HStack(spacing: 12) {
                Button {
                    currentStep = 1
                } label: {
                    Text("Back")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white.opacity(0.15))
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15
                            )
                        )
                }

                Button {
                    saveProfile()
                } label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.cyan)
                        .foregroundStyle(.black)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15
                            )
                        )
                }
            }
        }
        .padding()
        .background(.black.opacity(0.15))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }

    private func avatarButton(
        _ avatar: String
    ) -> some View {
        Button {
            withAnimation(.spring()) {
                selectedAvatar = avatar
            }
        } label: {
            ZStack {
                Circle()
                    .fill(
                        selectedAvatar == avatar
                        ? Color.cyan.opacity(0.4)
                        : Color.white.opacity(0.1)
                    )
                    .frame(width: 85, height: 85)

                Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            }
            .overlay {
                Circle()
                    .stroke(
                        selectedAvatar == avatar
                        ? Color.white
                        : Color.clear,
                        lineWidth: 3
                    )
                    .frame(width: 85, height: 85)
            }
            .overlay(alignment: .bottomTrailing) {
                if selectedAvatar == avatar {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white, .cyan)
                        .font(.title2)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var cleanedPlayerName: String {
        playerName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private var rankDescription: String {
        switch currentRank {
        case .rookie:
            return "Your gaming journey has started"

        case .challenger:
            return "You are becoming a regular player"

        case .skilled:
            return "Your skills are improving"

        case .elite:
            return "You are among the best players"

        case .legend:
            return "You have reached legendary status"
        }
    }

    private func saveProfile() {
        savedPlayerName = cleanedPlayerName
        savedAvatar = selectedAvatar
        dismiss()
    }
}

//#Preview {
//    ProfileSetupView(
//        manager: GameSessionManager()
//    )
//}
