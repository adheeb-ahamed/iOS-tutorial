//
//  QuizResultView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import SwiftUI

struct QuizResultView: View {

    let score: Int
    var gameMode: GameMode
    let total: Int
    let restartAction: () -> Void
    
    let unlockedProvince: SriLankaProvince?
    
    @State private var provinceForAlert: SriLankaProvince?

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

            VStack(spacing: 24) {
                Text("Quiz Completed")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                VStack(spacing: 12) {
                    Text("\(score) / \(total)")
                        .font(.system(size: 48, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.primary)

                    Text("Correct Answers")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)

                    Text(resultMessage)
                        .font(.system(.headline, design: .rounded))
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

                VStack(spacing: 12) {
                    Button(action: restartAction) {
                        Label("Play Again", systemImage: "arrow.counterclockwise")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            )
                    }

                    ShareLink(item: shareText) {
                        Label("Share Score", systemImage: "square.and.arrow.up")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            )
                    }
                }
                .padding(.horizontal, 24)
            }
        }.alert(
            "New Province Discovered!",
            isPresented: Binding(
                get: { provinceForAlert != nil },
                set: { newValue in if !newValue { provinceForAlert = nil } }
            ),
            actions: {
                Button("Continue", role: .cancel) {
                    provinceForAlert = nil
                }
            },
            message: {
                if let province = provinceForAlert {
                    Text(
                        """
                        You explored \(province.rawValue) Province.

                        You earned 200 coins!
                        """
                    )
                }
            }
        )
        .onAppear {
            DispatchQueue.main.async {
                provinceForAlert = unlockedProvince
            }
        }
        .onChange(of: unlockedProvince) { _, newProvince in
            provinceForAlert = newProvince
        }
    }

    var resultMessage: String {
        let percentage = Double(score) / Double(total)

        if percentage > 0.8 {
            return "Excellent!"
        } else if percentage > 0.5 {
            return "Good Job!"
        } else {
            return "Keep Practicing!"
        }
    }
}
