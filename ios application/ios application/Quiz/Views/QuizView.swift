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
    
    let columns = [
        GridItem (.flexible()),
        GridItem (.flexible())
    ]
    
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
        VStack (spacing : 40) {
            HStack{
                Text ("Score : \(vm.score)")
                    .font(.headline)
                
                Spacer()
                
                Text ("Question: \(vm.currentIndex + 1) of \(vm.questions.count)")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            Spacer()
            
            
            Text (vm.questions[vm.currentIndex].question)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 200) // Gives it that large box size
                .background(Color(.systemGray5)) // Light gray background
                .cornerRadius(12) // Rounded corners
                .padding(.horizontal)
            
            
            LazyVGrid(columns: columns, spacing : 16){
                ForEach(answerOptions, id: \.self){ option in
                    Button(action: {
                        vm.answer(option)
                    }){
                        Text (option)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity) // Makes button fill column width
                            .frame(height: 80)
                            .padding(.vertical, 20)      // Gives it that tall, thick look
                            .background(Color(.systemGray4)) // Light gray background
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            
        }
    }
    
    var answerOptions : [String] {
        let current = vm.questions[vm.currentIndex]
        
        return (current.incorrect_answers + [current.correct_answer]).shuffled()
        
    }

}  //end of quiz view


#Preview {
    QuizView(showGame: .constant(true))
}

