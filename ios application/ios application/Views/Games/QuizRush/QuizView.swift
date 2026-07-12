//
//  QuizView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//
import SwiftUI

struct QuizView: View {

    @StateObject var vm = QuizViewModel()
    
    let settings: QuizSettings

    @State var locationManager = LocationManager.shared

    @Binding var showGame: Bool
    
    
    
   

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Group {
            switch vm.viewState {
            case .loading:
                loadingView
            case .loaded:
                quizView
            case .error:
                errorView
            case .finished:
                QuizResultView(
                    score: vm.score,
                    gameMode: .quizRush,
                    total: vm.questions.count
                ) {
                    vm.resetGame()
                    vm.loadQuestions(settings: settings)
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .task {
            vm.loadQuestions(settings: settings)
        }
        .toolbar(.hidden, for: .tabBar)
    }

    var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading questions...")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
        }
    }

    var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Error loading questions")
                .font(.system(.headline, design: .rounded))
            Button("Retry") {
                Task { @MainActor in
                    vm.loadQuestions(settings: settings)
                }
            }
            .font(.system(.headline, design: .rounded))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
        }
    }

    var quizView: some View {
        VStack(spacing: 24) {
            HStack {
                metricCapsule(label: "Score", value: "\(vm.score)")
                Spacer()
                metricCapsule(
                    label: "Question",
                    value: "\(vm.currentIndex + 1) / \(vm.questions.count)"
                )
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()

            Text(vm.questions[vm.currentIndex].question)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .padding(20)
                .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(vm.answerOptions, id: \.self) { option in
                    Button(action: {
                        vm.answer(option)
                    }) {
                        Text(option)
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 72)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(color(for: option))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                            )
                    }
                    .buttonStyle(GrowingButton())
                    .disabled(vm.showAnswerResult)
                }
            }
            .padding(.horizontal)

            Spacer()
            
            timerCapsule
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
    }

    private func metricCapsule(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
        )
    }

    func color(for option: String) -> Color {
        guard vm.showAnswerResult else {
            return Color.gray.opacity(0.2)
        }

        let correct = vm.questions[vm.currentIndex].correctAnswer
        let selectedAnswer = vm.selectedAnswer

        if option == correct {
            return Color.green.opacity(0.35)
        }
        if option == selectedAnswer && option != correct {
            return Color.red.opacity(0.35)
        }
        return Color.gray.opacity(0.2)
    }
    
    private var timerCapsule: some View {
        HStack(spacing: 6) {
            Text("Time")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            Text("⏱\(vm.timeRemaining)")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    QuizView(
        settings : QuizSettings(),
        showGame: .constant(true)
    )
}

