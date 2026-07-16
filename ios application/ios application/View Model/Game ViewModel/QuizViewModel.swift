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
    private let locationManager = LocationManager.shared
    
    @Published private var unlockedProvince: SriLankaProvince?

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var viewState: ViewState = .loading
    @Published var selectedAnswer: String? = nil
    @Published var showAnswerResult: Bool = false
    @Published var answerOptions : [String] = []
    
    @Published var timeRemaining: Int = 60

    
    private var hasloaded = false // This is just a guard to check if api is loaded properly

    let service = QuizService()

    func loadQuestions(settings : QuizSettings) {
        
        timeRemaining = settings.timeLimit
        
        if hasloaded { return }
        hasloaded = true
        
        viewState = .loading
        print("loading started")

        Task {
            do {
                let fetched = try await service.getQuestions(settings: settings)
                print("Fetched questions", fetched.count)
                print("Starting api request")

                let decodedQuestions = fetched.map { question in
                    Question(
                        category: question.category,
                        difficulty: question.difficulty,
                        question: question.question.htmlDecoded,
                        correctAnswer: question.correctAnswer.htmlDecoded,
                        incorrectAnswers: question.incorrectAnswers.map { $0.htmlDecoded }
                    )
                }

                await MainActor.run {
                    self.questions = decodedQuestions
                    self.startTimer()
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
        
        let correct = questions[currentIndex].correctAnswer
        
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
            quizTimer?.invalidate()
            endGame()
            viewState = .finished
        }
    }

    func resetGame() {
        score = 0
        currentIndex = 0
        questions = []
        answerOptions = []
        selectedAnswer = nil
        showAnswerResult = false
        viewState = .loading
        hasloaded = false  
    }
    
    //This I created because when you click the answer it shuffles when showing the answer so this function shuffles only once.
    func loadAnswerOptions(){
        let current = questions[currentIndex]
        
        answerOptions = (current.incorrectAnswers + [current.correctAnswer]).shuffled()
    }
    
    func endGame(){
        print("Saving location:", locationManager.latitude, locationManager.longitude)
        
        let session = GameSessionModel(
            mode: .quizRush,
            score: score,
            timestamp: Date(),
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
        let result = GameSessionManager.shared.saveSessions(session)
        
        unlockedProvince = result
        
        
    }
    
    private var quizTimer: Timer?
    
    func startTimer() {
        quizTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            guard let self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }else {
                timer.invalidate()
                self.finishQuiz()
            }
        }
    }
    
    private func finishQuiz() {
        // stop timer and finish the quiz
        quizTimer?.invalidate()
        quizTimer = nil
        endGame()
        viewState = .finished
    }
    
    deinit {
        quizTimer?.invalidate()
    }
    
}

// End of QuizViewModel

