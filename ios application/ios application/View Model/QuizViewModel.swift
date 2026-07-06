//
//  QuizViewModel.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import Foundation
import Combine //observable object is defined in combine


enum ViewState {
    case loading
    case loaded
    case error
    case finished
}

class QuizViewModel: ObservableObject {

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var viewState: ViewState = .loading
    @Published var selectedAnswer: String? = nil
    @Published var showAnswerResult: Bool = false
    @Published var answerOptions : [String] = []

    
    private var hasloaded = false // This is just a guard to check if api is loaded properly

    let service = QuizService()

    func loadQuestions() {
        if hasloaded { return }
        hasloaded = true
        
        viewState = .loading
        print("loading started")

        Task {
            do {
                let fetched = try await service.getQuestions()
                print("Fetched questions", fetched.count)
                print("Starting api request")

                let decodedQuestions = fetched.map { question in
                    Question(
                        question: question.question.htmlDecoded,
                        correct_answer: question.correct_answer.htmlDecoded,
                        incorrect_answers: question.incorrect_answers.map { $0.htmlDecoded }
                    )
                }

                await MainActor.run {
                    self.questions = decodedQuestions
                    self.loadAnswerOptions()
                    self.viewState = .loaded
                    print("API request finished")
                }
            } catch {
                print("Error:", error)
                await MainActor.run {
                    self.viewState = .error
                }
            }
        }
    }

    // To check if the selected answer is correct
    func answer(_ selected: String) {
        guard !showAnswerResult else { return }
        
        selectedAnswer = selected
        showAnswerResult = true
        
        let correct = questions[currentIndex].correct_answer
        
        if selected == correct {
            score += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.nextQuestion( )
            self.selectedAnswer = nil
            self.showAnswerResult = false
        }
    }

    // This goes to the next question
    func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            loadAnswerOptions()
            print("Current Index:", currentIndex)
        } else {
            print("Quiz Finished!")
            viewState = .finished
        }
    }

    func resetGame() {
        score = 0
        currentIndex = 0
        questions = []
        viewState = .loading
        hasloaded = false  
    }
    
    //This I created because when you click the answer it shuffles when showing the answer so this function shuffles only once.
    func loadAnswerOptions(){
        let current = questions[currentIndex]
        
        answerOptions = (current.incorrect_answers + [current.correct_answer]).shuffled()
    }
}

// End of QuizViewModel
