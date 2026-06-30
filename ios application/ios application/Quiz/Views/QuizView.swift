//
//  QuizView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//
import SwiftUI

struct QuizView: View {
    
    @StateObject var vm = QuizViewModel()
    
    @Binding var showGame: Bool
    
    var body: some View {
        Group {
            switch vm.viewState {
            case .loading:
                ProgressView()
            case .loaded:
                quizView
            case .error:
                errorView
            }
        }
        .task { @MainActor in
            vm.loadQuestions()
        }
    }   //end of body
    
    //------------------------------------------------
    //  This is where loadingView takes place
    //---------------------------------------------
    
    var loadingView : some View {
        ProgressView("Loading...")
    } //end of loadingView
    
    
    
    //------------------------------------------------
    //  This is where errorView takes place
    //---------------------------------------------
    var errorView : some View {
        
        VStack {
            Text("Error loading questions")
            Button("Retry"){
                Task { @MainActor in
                    vm.loadQuestions()
                }
            }
        }
    } //End of errorView
    
    
    
    //------------------------------------------------
    //  This is where quizView takes place
    //---------------------------------------------
    var quizView : some View {
        VStack (spacing : 20) {
            
            Text (vm.questions[vm.currentIndex].question)
            
            ForEach(answerOptions, id: \.self){ option in
                Button(option){
                    vm.answer(option)
                }
                
            }
            Text("Score: \(vm.score)")
        }
    }
    
    var answerOptions : [String] {
        let current = vm.questions[vm.currentIndex]
        
        return (current.incorrect_answer + [current.correct_answer]).shuffled()
        
    }

}  //end of quiz view


#Preview {
    QuizView(showGame: .constant(true))
}

