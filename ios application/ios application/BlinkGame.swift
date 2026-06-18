//
//  BlinkGame.swift
//  ios application
//
//  Created by Student 3 on 2026-06-17.
//

import SwiftUI
import Combine

struct BlinkGame: View {
    
    @State private var scoreResult: Int = 0
    
    @State private var level : Int = 1
    
    //To create a timer
    @State private var timerLeft = 60                            //CHANGE THIS TESTING PURPOSE
    @State private var isTimerRunning = true
    
    //Dynamic array of cards
    @State private var cards: [Card] = [
        Card(isLit: false),
        Card(isLit: false),
        Card(isLit: false)
    ]
    
    //To get previous level
    @State private var previousLevel : Int = 1
    
    // To stop timer from running
    @State private var cancellable : Cancellable?
    
    //Game Over navigation layer
    @State private var goToGameover = false
    
    //Identifiable cards each unique
    struct Card : Identifiable {
        let id = UUID()
        var isLit: Bool
    }
    
    //create grid item
    let columns = [
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    //to get how much time is spent
    var elapsedTime: Int  {
        60 - timerLeft
    }

    
    //Create an internal timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: 410, height: 370)
                .shadow(color: .black, radius: 0.5)
                .position(x: 200, y: -100)
            
            
            //Title
            Text("Light it up!")
                .font(.largeTitle)
                .foregroundColor(Color.blue)
                .padding()
                .bold(true)
                .position(x: 110, y: 35)
            
            Text("Score")
                .font(.system(size: 20))
                .bold(true)
                .position(x: 55, y: 110)
            
            
            Text ("\(scoreResult)")
                .font(.system(size: 40))
                .bold(true)
                .foregroundStyle(Color.blue)
                .position(x: 55, y: 150)
            
            Text("Level: ")
                .font(.system(size: 20))
                .bold(true)
                .position(x: 295, y: 130)
            
            Text ("\(level)/4")
                .font(.system(size: 40))
                .bold(true)
                .foregroundStyle(Color.blue)
                .position(x: 360, y: 130)
            
            Text ("Cards : \(cards.count)")
                .position(x: 200, y: 190)
            
            
            VStack{
                LazyVGrid(columns : columns){
                    ForEach(cards) { card in
                        Button(action: {
                            //ACTION HERE
                            if card.isLit
                            {
                                scoreResult += 1
                            }else{
                                
                                if scoreResult <= 2 {
                                    scoreResult = 0
                                }else{
                                    scoreResult -= 3
                                }
                            }
                            
                        }) {
                            Rectangle()
                                .fill(card.isLit ? Color.yellow : Color.blue)
                                .frame (width: 115, height: 120)
                                .cornerRadius(12)
                                
                                
                        }
                    }
                } //Lazy grid
            }
            .position(x: 200, y: 420)
            
            
            Text("Timer: \(timerLeft)")
                .font(.system(size: 20))
                .bold(true)
                .foregroundStyle(Color.blue)
                .position(x: 200, y: 730)
            
            
        }// End of Zstack
        //this modifier explains the each passing second of timer
        .onReceive(timer) { _ in
            guard isTimerRunning && timerLeft > 0 else{
                if timerLeft == 0{
                    isTimerRunning = false
                    stopTimer()
                    
                    DispatchQueue.main.async {
                        goToGameover = true
                    }
                }
                return
            }
                timerLeft -= 1
                
            
                
                
                let newLevel : Int
            
                //Level checker
                if elapsedTime < 15 {
                    newLevel = 1
                }
                else if elapsedTime < 30 {
                    newLevel = 2
                }
                else if elapsedTime < 45 {
                    newLevel = 3
                }
                else{
                    newLevel = 4
                }
            
                if newLevel != level {
                    level = newLevel
                    setupCards(for: level)
                }
            
                for i in cards.indices {
                    cards[i].isLit = false
                }
            
            
            
            if let index = cards.indices.randomElement() {
                cards[index].isLit = true
            }
                
            
        }
        //After GameOverView it comes back to this layer
        .navigationDestination(isPresented: $goToGameover) {
            GameOverView(score: scoreResult) {
                print ("Restart pressed")
                resetGame()
                goToGameover = false
            }
        }
        
    }
    
    // For each level card increases and then lights 
    func setupCards(for newLevel: Int){
        switch newLevel {
        case 1:
            cards = (0..<3).map{ _ in Card(isLit: false)}
            
        case 2:
            cards = (0..<4).map{ _ in Card(isLit: false)}
            
        case 3:
            cards = (0..<6).map{ _ in Card(isLit: false)}
            
        case 4:
            cards = (0..<9).map{ _ in Card(isLit: false)}
            
        default :
            break
        }
    }
    
    
    func resetGame(){
        scoreResult = 0
        level = 1
        isTimerRunning = true
        setupCards(for: level)
        timerLeft = 60                      //CHANGE THIS FOR TESTING PURPOSE
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
}

#Preview {
    BlinkGame()
}

