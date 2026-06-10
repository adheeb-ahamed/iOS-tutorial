import SwiftUI

//
//  Untitled.swift
//  ios application
//
//  Created by Student 3 on 2026-06-10.
//

struct GameOverView: View {
    var score: Int
    var onRestart: () -> Void //the moment you click restart it becomes zero
    
    var body: some View {
        
        VStack (spacing: 20){
            Text("Game Over")
                .font(.largeTitle)
                .padding()
                .foregroundColor(Color.red)
                .padding()
            
            
            Text("Score: \(score)")
                .font(.system(size: 30))
            
            Button ("Play Again"){
                onRestart() //Once you click the button restart 
            }
            .padding()
        }
    }
}


