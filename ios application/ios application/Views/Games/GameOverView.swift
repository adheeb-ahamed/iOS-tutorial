import SwiftUI

//
//  Untitled.swift
//  ios application
//
//  Created by Student 3 on 2026-06-10.
//

struct GameOverView: View {
    var score: Int
    var gameMode: GameMode
    var onRestart: () -> Void //the moment you click restart it becomes zero
    var onHome: () -> Void
    
    
    
    
    //Dismiss the current screen
    @Environment(\.dismiss) private var dismiss
    
    
    var shareText: String  {
        """
        I scored \(score) points in \(gameMode.rawValue)!
        
        Can you beat my score?
        """
    }
    
    
    var body: some View {
        
        VStack (spacing: 20){
            Text("Game Over")
                .font(.system(size: 50))
                .padding()
                .foregroundColor(Color.red)
                .padding()
                .bold(true)
            
            
            Text("Score: \(score)")
                .font(.system(size: 30))
            
            HStack (spacing : 30){
                Button {
                    onRestart() //Once you click the button restart and resets the timer and score

                } label : {
                    Image("undo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .contentShape(Circle())
                .padding()
                
                
                Button {
                    onHome() //Once you click the button, you go to home page

                } label : {
                    Image("home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .contentShape(Circle())
                .padding()
                
                
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                
            }
            .padding()
            
        }
        .navigationBarBackButtonHidden(true) //Remove the back button that is created automatically by the navigation stack
    }
}

#Preview {
    GameOverView(
        score: 100,
        gameMode: .tapFrenzy,
        onRestart: {
            print("Restart clicked")
        },
        onHome: {
            print("Home clicked")
        }
    )
}

