//
//  DailyChallengeCover.swift
//  ios application
//
//  Created by student5 on 2026-07-09.
//
import SwiftUI


struct DailyChallengeBanner: View {
    let challenge: DailyChallengeModel
    @ObservedObject var manager: DailyChallengeManager
    var onPlayChallenge: (GameMode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Daily Challenge")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Text(challenge.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(challenge.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button {
                onPlayChallenge(challenge.targetMode)
            } label: {
                Text("Play Challenge")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
