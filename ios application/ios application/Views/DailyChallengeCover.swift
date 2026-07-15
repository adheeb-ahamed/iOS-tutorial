import SwiftUI

struct DailyChallengeBanner: View {

    let challenge: DailyChallengeModel
    @ObservedObject var manager: DailyChallengeManager

    var onPlayChallenge: (GameMode) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            headerSection

            challengeDetails

            playButton
        }
        .padding(20)
        .background(bannerBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    Color.white.opacity(0.25),
                    lineWidth: 1
                )
        }
        .shadow(
            color: Color.blue.opacity(0.25),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(spacing: 12) {

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.20))
                    .frame(width: 48, height: 48)

                Image(systemName: "trophy.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.yellow)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("DAILY CHALLENGE")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.75))

                Text("Today's Mission")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            Spacer()

            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundStyle(.orange)
                .symbolEffect(.pulse)
        }
    }

    // MARK: - Challenge Details

    private var challengeDetails: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(challenge.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(challenge.description)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.80))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Image(systemName: "gamecontroller.fill")

                Text(gameModeName)
                    .fontWeight(.semibold)
            }
            .font(.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.white.opacity(0.16))
            .clipShape(Capsule())
        }
    }

    // MARK: - Play Button

    private var playButton: some View {
        Button {
            onPlayChallenge(challenge.targetMode)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")

                Text("Play Challenge")
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "arrow.right")
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(1)
    }

    // MARK: - Background

    private var bannerBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.95),
                    Color.indigo.opacity(0.90),
                    Color.purple.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 160, height: 160)
                .offset(x: 130, y: -80)

            Circle()
                .fill(Color.cyan.opacity(0.15))
                .frame(width: 120, height: 120)
                .offset(x: -140, y: 100)
        }
    }

    // MARK: - Game Mode Name

    private var gameModeName: String {
        switch challenge.targetMode {
        case .tapFrenzy:
            return "Tap Frenzy"

        case .lightItUp:
            return "Light It Up"

        case .quizRush:
            return "Quiz Rush"
        }
    }
}
