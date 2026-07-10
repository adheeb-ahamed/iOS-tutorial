import SwiftUI

//
//  Untitled.swift
//  ios application
//
//  Created by Student 3 on 2026-06-10.
//

struct GameOverView: View {
    var score: Int
    var gameMode: GameMode
    var onRestart: () -> Void
    var onHome: () -> Void

    @Environment(\.dismiss) private var dismiss

    var shareText: String {
        """
        I scored \(score) points in \(gameMode.rawValue)!

        Can you beat my score?
        """
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("Game Over")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color.red.opacity(0.75))

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
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 24)

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
                                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func actionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
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
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
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
}
