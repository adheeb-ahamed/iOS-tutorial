//
//  ContentView.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        
        
        VStack {
            
        
            Text("Score : \(count)")
                .font(.system(size:30))
            
            Spacer()
            
            Button {
                count += 1
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
            
            Text("Timer")
                .font(.system(size:30))
            
            
            
                }
            }
        }
        

#Preview {
    ContentView()
}
