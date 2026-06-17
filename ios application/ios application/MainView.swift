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
    
    var body: some View {
    NavigationStack {
        ScrollView{
                ZStack{
                    
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
                    
                    Text ("Tap the button and score")
                        .position(x: 164, y: 795)
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
                        
                    
                    
                    
                    
      
                        
                    
                    
                        VStack(spacing : 20){
                            
                        
                        } //End of VStack
                        
                    } //End of ZStack
                    .navigationDestination(isPresented: $startTapGame) {
                        ContentView()
                }
        }
        
        
        }//End of Navigation Stack
        
    }
        
        
        
    }//End of MainView

#Preview {
    MainView()
}

