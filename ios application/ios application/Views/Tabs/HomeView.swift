//
//  MainView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-14.
//
import SwiftUI

struct MainView: View {
    
    // To go to Tap Game
    @State private var startTapGame = false
    
    //To go to Light it up game
    @State private var startLightItUpGame = false
    
    //To go to Quiz Rush game
    @State private var startQuizRush = false
    
    
    
    var body: some View {
    NavigationStack {
        ZStack{
            
            ScrollView{
                    ZStack{
                        
                        //Ready to play
                        Text("Ready to play")
                            .font(.system(size: 29, weight: .semibold, design: .rounded))
                            .position(x: 120, y: 120)
                        
                
                        Text ("Simple light minded games")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .position(x: 145, y: 155)
                        
                        //Image with rounded rectangle
                        Image("tapImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 362)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 380)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 250)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 410)
                        
                        
                        Text("Tap \nFrenzy")
                            .font(.largeTitle)
                            .padding()
                            .bold(true)
                            .position(x: 130, y: 350)
                        
                        Text ("Tap the button and score")
                            .position(x: 164, y: 395)
                            .padding()
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        
                        Button(action: {
                            startTapGame = true
                        }, label: {
                            Text("Play")
                                .frame(width: 250, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                                .cornerRadius(15)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        })
                        .position(x: 200, y: 480)
                        
                        
                        //2ND GAME
                        //Image with rounded rectangle
                        Image("lightImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 362)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 780)
                            
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 250)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 810)
                        
                        
                        Text("Light it \nup")
                            .font(.largeTitle)
                            .padding()
                            .bold(true)
                            .position(x: 130, y: 750)
                        
                        Text ("Light the button before it dims")
                            .position(x: 183, y: 795)
                            .padding()
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        
                        Button(action: {
                            startLightItUpGame = true
                        }, label: {
                            Text("Play")
                                .frame(width: 250, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                                .cornerRadius(15)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        })
                        .position(x: 200, y: 880)
                        
                        
                        
                        //3rd Image
                        
                        //Image with rounded rectangle
                        Image("tapImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 362)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 1180)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 250)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 0.5)
                            .position(x: 200, y: 1210)
                        
                        
                        Text("Quiz \nRush")
                            .font(.largeTitle)
                            .padding()
                            .bold(true)
                            .position(x: 130, y: 1150)
                        
                        Text ("Select correct answer")
                            .position(x: 164, y: 1195)
                            .padding()
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        
                        Button(action: {
                            startQuizRush = true
                        }, label: {
                            Text("Play")
                                .frame(width: 250, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                                .cornerRadius(15)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        })
                        .position(x: 200, y: 1280)
                            
          
                            Spacer()
                        

                            
                        } //End of ZStack
                        .navigationDestination(isPresented: $startTapGame) {
                            ContentView(showGame: $startTapGame)
                        }
                        .navigationDestination(isPresented: $startLightItUpGame){
                            BlinkGame(showGame: $startLightItUpGame)
                        }
                        .navigationDestination(isPresented: $startQuizRush){
                            QuizView(showGame: $startQuizRush)
                        }
                        .padding(.bottom, 1000)
                
            }//scrollable view
            
            //Top rectangle with the title
            Rectangle()
                .fill(Color.white)
                .frame(width: 410, height: 150)
                .shadow(color: .black, radius: 0.5)
                .position(x: 200, y: 0)
            
            //Title
            Text("Velocity")
                .font(.largeTitle)
                .foregroundColor(Color.blue)
                .padding()
                .bold(true)
                .position(x: 200, y: 30)
        }
        
        
        }//End of Navigation Stack
        
    }
        
        
        
    }//End of MainView

#Preview {
    MainView()
}

