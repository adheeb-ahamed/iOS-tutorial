//
//  ContentView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var count = 0  //To get the changing score counter
    
    //To create a timer
    @State private var timerLeft = 10                            //CHANGE THIS TESTING PURPOSE
    @State private var isTimerRunning = false
    
    //New navigation layer
    @State private var goToGameover = false
    
    //Change of button size
    @State private var buttonSize : CGFloat = 200
    
    //Change the button size
    @State private var xPosition : CGFloat = 200
    @State private var yPosition : CGFloat = 350
    
    //I want to change the font size at the same time
    @State private var fontSize : CGFloat = 30
    
    @State private var isRed: Bool = true
    
    var targetColor : Color {
        isRed ? Color.red : Color.yellow
    }
    
    var targetText : String {
        isRed ? "Tap me!" : "Bonus!"
    }
    
    
    
    //Create an internal timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Body
    var body: some View {
        
        //Changes from this view to other view
        NavigationStack {
            
            //Enter layer
            ZStack {
//                Color(
//                    red:200 / 255,
//                    green: 243 / 255,
//                    blue: 247 / 255
//                ).ignoresSafeArea(edges: .all) //color the entire area
                
                
                //Vertical layer
                VStack {
                    
                    Text("Score : \(count)")
                        .font(.system(size: 30))

                    Spacer()

                    Button {
                        if timerLeft <= 10 && timerLeft > 0 {
                            if isRed {
                                count += 1
                            } else {
                                count += 5
                            }
                        }

                        if timerLeft == 10 {                 //CHANGE THIS TESTING PURPOSE
                            isTimerRunning = true
                        }
                    } label: {
                        Text(targetText)
                            .frame(width: buttonSize, height: buttonSize)
                            .padding()
                            .background(targetColor)
                            .foregroundColor(Color.white)
                            .font(.system(size: fontSize))
                            .clipShape(Circle())
                        
                    }
                    .position(x: xPosition, y: yPosition)

                    Spacer()

                    Text("Timer: \(timerLeft)")
                        .font(.system(size: 30))
                }//End of VStack
                
            } //End of ZStack
            
            
            
            //this modifier explains the each passing second of timer
            .onReceive(timer) { _ in
                if isTimerRunning && timerLeft > 0 {
                    timerLeft -= 1
                    fontSize -= 1.5
                    withAnimation(.easeInOut(duration:0.9)){
                        buttonSize -= 15
                    }
                    
                    if timerLeft % 4 == 0 {
                        toggleTarget()
                    }
                    moveTarget()
                    
                } else if timerLeft == 0 {
                    isTimerRunning = false
                    goToGameover = true
                }
                
            }
            
            //After GameOverView it comes back to this layer
            .navigationDestination(isPresented: $goToGameover) {
                GameOverView(score: count) {
                    resetGame()
                    goToGameover = false
                }
            }
        }
    }

    //This functions reset the entire score and time once you are navigated from gameOverView to this view
    func resetGame() {
        count = 0
        timerLeft = 10                          //CHANGE THIS FOR TESTING PURPOSE ONLY
        isTimerRunning = false
        buttonSize = 200
        xPosition = 200
        yPosition = 350
        fontSize = 30
        isRed = true
    }
    
    // This function is created to move the function of the button
    func moveTarget() {
        
        withAnimation(.easeInOut(duration:0.5)){
            xPosition = CGFloat.random(in: 100...300)
            yPosition = CGFloat.random(in: 100...500)
        }

    }
    
    func toggleTarget()
    {
        withAnimation(.easeInOut(duration: 0.3)){
            isRed.toggle( )
        }
    }
}

#Preview {
    ContentView()
}

