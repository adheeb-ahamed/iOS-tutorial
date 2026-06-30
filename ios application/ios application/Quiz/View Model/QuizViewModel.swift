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
}

class QuizViewModel : ObservableObject {
    
    @Published var questions : [Question] = []
    @Published var currentIndex : Int = 0
    @Published var score : Int = 0
    @Published var viewState : ViewState = .loading
    
    
    let service = QuizService()

    
    func loadQuestions() {
        self.viewState = .loading
        print("loading started")
        
        Task {
            do {
                let fetched = try await service.getQuestions()
                print("Fetched questions", fetched.count)
                
                DispatchQueue.main.async {
                    self.questions = fetched
                    self.viewState = .loaded
                    print("State changed to loaded")
                }
                
                
            } catch {
                print("Error :", error)
                
                DispatchQueue.main.async {
                    self.viewState = .error
                }
            }
        }
    }
    
    
    //To check if the selected answer is correct
    func answer(_ selected : String){
        
        let correct = questions[currentIndex].correct_answer
        
        if selected == correct {
            score += 1
        }
        
        nextQuestion()
    }
    
    
    //This is go to next question
    func nextQuestion(){
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }else {
            viewState = .loaded
        }
    }
    
    func resetGame() {
        score = 0
        currentIndex = 0
        viewState = .loading
    }

} //End of quiz model view



