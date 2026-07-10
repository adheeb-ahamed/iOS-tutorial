//
//  QuizSettingsView.swift
//  ios application
//
//  Created by student5 on 2026-07-11.
//

import SwiftUI

struct QuizSettingsView: View {

    @State private var settings = QuizSettings()

    @State private var startQuiz = false

    var body: some View {

        NavigationStack {

            Form {

                Section("Number of Questions") {

                    Picker("Questions", selection: $settings.amount) {

                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("15").tag(15)
                        Text("20").tag(20)
                    }
                }

                Section("Difficulty") {

                    Picker("Difficulty", selection: $settings.difficulty) {

                        ForEach(Difficulty.allCases) { difficulty in

                            Text(difficulty.title)
                                .tag(difficulty)
                        }
                    }
                }

                Section("Category") {

                    Picker("Category", selection: $settings.category) {

                        ForEach(QuizCategory.allCases) { category in

                            Text(category.title)
                                .tag(category)
                        }
                    }
                }

                Section("Time Limit") {

                    Picker("Time", selection: $settings.timeLimit) {

                        Text("30 Seconds").tag(30)
                        Text("60 Seconds").tag(60)
                        Text("90 Seconds").tag(90)
                        Text("120 Seconds").tag(120)
                    }
                }

                Button("Start Quiz") {

                    startQuiz = true
                }
            }
            .navigationTitle("Quiz Settings")

            .navigationDestination(isPresented: $startQuiz) {

                QuizView(
                    settings: settings,
                    showGame: .constant(true)
                )
            }
        }
    }
}
