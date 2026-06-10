//
//  ContentView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var count = 0
    @State private var timerLeft = 10
    @State private var isTimerRunning = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        
        VStack {
            
            
            Text("Score : \(count)")
                .font(.system(size:30))
            
            Spacer()
            
            Button {
                if timerLeft <= 10 && timerLeft > 0{
                    count += 1
                }
                
                if timerLeft == 10 {
                    isTimerRunning = true
                }
            } label: {
                Text("Tap me!")
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(.system(size:30))
                    .clipShape(Circle())
                
            }
            
            Spacer()
            
            Text("Timer: \(timerLeft)")
                .font(.system(size:30))
            
            
            
            
        }
        .onReceive(timer) { _ in
            if isTimerRunning && timerLeft > 0 {
                timerLeft -= 1
            } else if timerLeft == 0 {
                isTimerRunning = false
                
            }
        }
    }
}
#Preview {
    ContentView()
}

