//
//  ContentView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI
import Combine
import AVFoundation

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
    
    
    // To stop timer from running
    @State private var cancellable : Cancellable?
    
    
//    @State private var isRed: Bool = true
    
    
    @State private var currentTarget: targetType = .red
    
    @State private var tickCount = 0
    
    //This is to add a sound
    @State private var audioPlayer : AVAudioPlayer?
    
    
    //Checks if the color is red
//    var targetColor : Color {
//        isRed ? Color.red : Color.yellow
//    }
    
    //if the color is red the text changes
//    var targetText : String {
//        isRed ? "Tap me!" : "Bonus!"
//    }
    
    enum targetType{
        case red
        case yellow
        case bomb
    }
    
    
    enum GameState{
        case playing
        case gameOver
    }
    
    
    
    //Create an internal timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Body
    var body: some View {
        
        //Changes from this view to other view
        //NO NEED OF TWO NAVIGATION STACK 
        //NavigationStack {
            
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
                            
//                            if isRed {
//                                count += 1
//                            } else {
//                                count += 5
//                            }
                            
                            // Button score for each tap and color
                            switch currentTarget{
                                
                            case .red
                                : count += 1
                                print ("red is being tapped")
                                playSound(named: "points")
                                
                            case .yellow
                                : count += 5
                                print ("Yellow is being tapped")
                                playSound(named: "bonus")
                                
                            case .bomb
                                : count -= 10
                                print ("bomb is being tapped")
                                playSound(named: "bomb")
                            }//end of switch
                        }

                        if timerLeft == 10 {                 //CHANGE THIS TESTING PURPOSE
                            isTimerRunning = true
                        }
                    } label: {
                        
                        switch currentTarget {
                            
                        case .red:
                            Text("Tap me!")
                                .frame(width: buttonSize, height: buttonSize)
                                .padding()
                                .background(.red)
                                .foregroundColor(Color.white)
                                .font(.system(size: fontSize))
                                .clipShape(Circle())
                            
                            
                        case .yellow:
                            Text ("Bonus!")
                                .frame(width: buttonSize, height: buttonSize)
                                .padding()
                                .background(.yellow)
                                .foregroundColor(Color.white)
                                .font(.system(size: fontSize))
                                .clipShape(Circle())
                            
                            
                        case .bomb:
                            Image("bomb-4")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                                .scaledToFit()
                                .sensoryFeedback(.success, trigger: currentTarget)
                        }
                    
                        
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
                    tickCount += 1
                    
                    
                    if tickCount % 1 == 0 {
                        generateTarget()
                        moveTarget()
                    }
                    
                    //this allows that after a second of bonus points it will turn back to red
                    //                    if !isRed {
                    //                        toggleTarget()
                    //                    }
                    
                    //To match with the font size
                    fontSize -= 1.5
                    
                    //reduces the button size
                    withAnimation(.easeInOut(duration:0.9)){
                        buttonSize -= 15
                    }
                    
                    //ever 4 seconds the button will change to yellow
//                    if timerLeft % 2 == 0 {
//                        generateTarget()
//                    }
//                    
//                    moveTarget()
                    
                    } else if timerLeft == 0 && !goToGameover {
                        goToGameover = true
                        isTimerRunning = false
                        stopTimer()
                    }
                
                
                
            }
            
            //After GameOverView it comes back to this layer
            .navigationDestination(isPresented: $goToGameover) {
                GameOverView(score: count) {
                    print ("Restart pressed")
                    resetGame()
                    goToGameover = false
                }
            }
       // }
    }

    //This functions reset the entire score and time once you are navigated from gameOverView to this view
    func resetGame() {
        print ("Resetting game")
        stopTimer()
        count = 0
        timerLeft = 10                          //CHANGE THIS FOR TESTING PURPOSE ONLY
        isTimerRunning = false
        buttonSize = 200
        xPosition = 200
        yPosition = 350
        fontSize = 30
        currentTarget = .red
//        isRed = true
    }
    
    // This function is created to move the function of the button
    func moveTarget() {
        
        withAnimation(.easeInOut(duration:0.5)){
            xPosition = CGFloat.random(in: 100...300)
            yPosition = CGFloat.random(in: 100...500)
        }

    }
    
//    func toggleTarget()
//    {
//        withAnimation(.easeInOut(duration: 0.3)){
//            isRed.toggle( )
//        }
//    }
    
    
    func generateTarget() {
        let targets : [targetType] = [
            .red,
            .red,
            .red,
            .yellow,
            .bomb
        ]
        
        currentTarget = targets.randomElement()!
        
    }
    
    //To start or cancel timer
    func startTimer() {
        // Using autoconnect on the timer; nothing needed here for now.
        // Keep this in case you later want manual control.
        // cancellable = timer.connect()
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func playSound(named SoundName: String) {
        guard let url = Bundle.main.url(forResource: SoundName, withExtension: "mp3") else {
            print("Sound not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("error playing sound : \(error)")
        }
    }
}


#Preview("ContentView Reset Game") {
    NavigationStack {
        ContentView()
    }
}

