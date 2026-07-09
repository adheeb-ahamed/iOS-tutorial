//
//  GameCardView.swift
//  ios application
//
//  Created by student5 on 2026-07-09.
//


import SwiftUI

struct GameCardView: View {
    let title: String
    let subtitle: String
    let backgroundImageName: String
    var onPlayTapped: () -> Void
    
    var body: some View {
        Button(action: onPlayTapped) {
            ZStack {
                // 1. Core Card Background Image
                Image(backgroundImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        // Gives it a clean outer border edge like your game hub reference
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                
                // 2. Text Content & Action Button Layout Overlay
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Spacer() // Pushes contents safely to the bottom/center
                        
                        Text(title)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 2)
                        
                        Text(subtitle)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.8), radius: 1, x: 1, y: 1)
                            .lineLimit(2)
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        // Native SwiftUI styling to resemble a rounded game play button
                        Text("Play")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.primary) // Automatically adapts text color nicely
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                            )
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 20)
                }
            }
            .frame(height : 180)
            .contentShape(RoundedRectangle(cornerRadius: 24))
        }
        .buttonStyle(GrowingButton())
    }
}

// Micro-interaction helper for game-like feel when selecting options
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
