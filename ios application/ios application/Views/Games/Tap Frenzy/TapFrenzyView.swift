//
//  TapFrenzyView.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//


import SwiftUI

struct TapFrenzyView: View {

    @StateObject private var viewModel = TapFrenzyViewModel()

    @Binding var showGame: Bool

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                scoreHeader

                GeometryReader { geometry in
                    targetButton
                        .position(
                            x: clampedXPosition(
                                in: geometry.size
                            ),
                            y: clampedYPosition(
                                in: geometry.size
                            )
                        )
                        .animation(
                            .easeInOut(duration: 0.5),
                            value: viewModel.xPosition
                        )
                        .animation(
                            .easeInOut(duration: 0.5),
                            value: viewModel.yPosition
                        )
                        .animation(
                            .easeInOut(duration: 0.9),
                            value: viewModel.buttonSize
                        )
                        .onAppear {
                            viewModel.updatePlayArea(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                        }
                        .onChange(of: geometry.size) { _, newSize in
                            viewModel.updatePlayArea(
                                width: newSize.width,
                                height: newSize.height
                            )
                        }
                }

                timerCapsule
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.prepareGame()
        }
        .onDisappear {
            viewModel.stopGame()
        }
        .navigationDestination(
            isPresented: $viewModel.goToGameOver
        ) {
            GameOverView(
                score: viewModel.score,
                gameMode: .tapFrenzy,
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

    // MARK: - Header

    private var scoreHeader: some View {
        HStack(spacing: 12) {
            metricCapsule(
                label: "Score",
                value: "\(viewModel.score)"
            )

            Spacer()

            metricCapsule(
                label: "High Score",
                value: "\(viewModel.highScore)"
            )
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private func metricCapsule(
        label: String,
        value: String
    ) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(
                    .system(
                        .caption,
                        design: .rounded
                    )
                )
                .foregroundColor(.secondary)

            Text(value)
                .font(
                    .system(
                        .title3,
                        design: .rounded
                    )
                )
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
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
    }

    // MARK: - Target

    @ViewBuilder
    private var targetButton: some View {
        Button {
            viewModel.tapTarget()
        } label: {
            switch viewModel.currentTarget {
            case .red:
                circularTarget(
                    text: "Tap me!",
                    background: Color.red.opacity(0.85),
                    foreground: .white
                )

            case .yellow:
                circularTarget(
                    text: "Bonus!",
                    background: Color.yellow.opacity(0.9),
                    foreground: .primary
                )

            case .bomb:
                bombTarget
            }
        }
        .buttonStyle(.plain)
    }

    private func circularTarget(
        text: String,
        background: Color,
        foreground: Color
    ) -> some View {
        Text(text)
            .font(
                .system(
                    size: viewModel.fontSize,
                    design: .rounded
                )
            )
            .fontWeight(.bold)
            .frame(
                width: viewModel.buttonSize,
                height: viewModel.buttonSize
            )
            .background(background)
            .foregroundColor(foreground)
            .clipShape(Circle())
            .shadow(
                color: .black.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
    }

    private var bombTarget: some View {
        Image("bomb-4")
            .resizable()
            .scaledToFit()
            .frame(
                width: viewModel.buttonSize,
                height: viewModel.buttonSize
            )
            .shadow(
                color: .black.opacity(0.2),
                radius: 6,
                x: 0,
                y: 3
            )
            .sensoryFeedback(
                .warning,
                trigger: viewModel.currentTarget
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

            Text("\(viewModel.timerLeft)s")
                .font(
                    .system(
                        .title3,
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

    // MARK: - Position helpers

    private func clampedXPosition(
        in size: CGSize
    ) -> CGFloat {
        let halfSize = viewModel.buttonSize / 2

        let minimum = halfSize
        let maximum = max(
            minimum,
            size.width - halfSize
        )

        return min(
            max(viewModel.xPosition, minimum),
            maximum
        )
    }

    private func clampedYPosition(
        in size: CGSize
    ) -> CGFloat {
        let halfSize = viewModel.buttonSize / 2

        let minimum = halfSize
        let maximum = max(
            minimum,
            size.height - halfSize
        )

        return min(
            max(viewModel.yPosition, minimum),
            maximum
        )
    }
}

#Preview {
    NavigationStack {
        TapFrenzyView(showGame: .constant(true))
    }
}