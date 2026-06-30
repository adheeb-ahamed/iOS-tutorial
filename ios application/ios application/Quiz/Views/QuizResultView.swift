//
//  QuizResultView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import SwiftUI

struct QuizResultView: View {

    let score: Int
    let total: Int
    let restartAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Text("Quiz Completed")
                .font(.largeTitle)
                .bold()

            Text("Score: \(score) / \(total)")
                .font(.title2)

            Text(resultMessage)
                .font(.headline)
                .foregroundColor(.gray)

            Button("Play Again") {
                restartAction()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
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
