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
        
        VStack(spacing : 20){
            Text("Velocity")
                .font(.largeTitle)
                .foregroundColor(Color.blue)
                .padding()
                .bold(true)
            
            
        
            Text ("Tap Frenzy")
            
            Button ("Play"){
                startTapGame = true
            }
            
        } //End of VStack
        .navigationDestination(isPresented: $startTapGame) {
            ContentView()
        }
    } //End of Navigation Stack
    }
        
        
        
    }//End of MainView

#Preview {
    MainView()
}
