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

    struct Avatar: Identifiable {
        let id = UUID()
        let image: String
        let name: String
        let price: Int
    }
    
    private let avatars: [Avatar] = [
        Avatar(image: "chess",       name: "Chess Master", price: 0),
        Avatar(image: "car",         name: "Speed Racer",  price: 150),
        Avatar(image: "football",    name: "Striker",      price: 250),
        Avatar(image: "fire",        name: "Flame",        price: 400),
        Avatar(image: "ninja",       name: "Shadow",       price: 600),
        Avatar(image: "heart-love",  name: "Cupid",        price: 1000)
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
    
    @EnvironmentObject private var coinManager: CoinManager

    @AppStorage("ownedAvatarIDs")
    private var ownedAvatarIDsData = "chess"

    @State private var showNotEnoughCoinsAlert = false
    
    private var ownedAvatarIDs: Set<String> {
        Set(
            ownedAvatarIDsData
                .split(separator: ",")
                .map(String.init)
        )
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
        .alert(
            "Not Enough Coins",
            isPresented: $showNotEnoughCoinsAlert
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(
                "Play more games to earn enough coins for this avatar."
            )
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

            
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(.yellow)

                Text("\(coinManager.balance) Coins")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding()
            .background(.white.opacity(0.12))
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
            
            LazyVGrid(
                columns: columns,
                spacing: 18
            ) {
                ForEach(avatars) { avatar in
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

    private func avatarButton(_ avatar: Avatar) -> some View {

        let isOwned = ownedAvatarIDs.contains(avatar.image)
        let isSelected = selectedAvatar == avatar.image

        return Button {
            if isOwned {
                withAnimation(.spring()) {
                    selectedAvatar = avatar.image
                }
            } else {
                purchaseAvatar(avatar)
            }
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                            ? Color.cyan.opacity(0.4)
                            : Color.white.opacity(0.1)
                        )
                        .frame(width: 85, height: 85)

                    Image(avatar.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .saturation(isOwned ? 1 : 0)
                        .opacity(isOwned ? 1 : 0.55)

                    if !isOwned {
                        Circle()
                            .fill(.black.opacity(0.35))
                            .frame(width: 72, height: 72)

                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
                .overlay {
                    Circle()
                        .stroke(
                            isSelected
                            ? Color.white
                            : Color.clear,
                            lineWidth: 3
                        )
                        .frame(width: 85, height: 85)
                }
                .overlay(alignment: .bottomTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .cyan)
                    }
                }

                Text(avatar.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                if isSelected {
                    Label(
                        "Selected",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.cyan)

                } else if isOwned {
                    Label(
                        "Owned",
                        systemImage: "checkmark.seal.fill"
                    )
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)

                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")

                        Text("\(avatar.price)")
                            .fontWeight(.bold)
                    }
                    .font(.caption)
                    .foregroundStyle(.yellow)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func avatarStatusView(
        avatar: Avatar,
        isOwned: Bool,
        isSelected: Bool
    ) -> some View {
        if isSelected {
            Label("Selected", systemImage: "checkmark.circle.fill")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
        } else if isOwned {
            Label("Owned", systemImage: "checkmark.seal.fill")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.green)
        } else {
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(.yellow)

                Text("\(avatar.price)")
                    .fontWeight(.bold)
                    .foregroundStyle(.yellow)
            }
            .font(.caption2)
        }
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
    
    private func purchaseAvatar(_ avatar: Avatar) {
        // If already owned, just select it
        if ownedAvatarIDs.contains(avatar.image) {
            withAnimation(.spring()) {
                selectedAvatar = avatar.image
            }
            return
        }

        // Check coin balance
        if coinManager.balance < avatar.price {
            showNotEnoughCoinsAlert = true
            return
        }

        guard coinManager.spendCoins(amount: avatar.price) else {
            showNotEnoughCoinsAlert = true
            return
        }

        // Persist ownership in AppStorage as a comma-separated list
        var ids = ownedAvatarIDs
        ids.insert(avatar.image)
        ownedAvatarIDsData = ids.sorted().joined(separator: ",")

        // Select newly purchased avatar
        withAnimation(.spring()) {
            selectedAvatar = avatar.image
        }
    }
}

#Preview {
    ProfileSetupView(
        manager: GameSessionManager.shared
    )
    .environmentObject(CoinManager.shared)
}
