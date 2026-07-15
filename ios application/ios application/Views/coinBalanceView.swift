//
//  coinBalanceView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-15.
//

import SwiftUI


struct coinBalanceView: View {
    
    
    @EnvironmentObject var coinManager: CoinManager
    
    var body : some View {
        
        HStack (spacing : 6) {
            
            Image(systemName: "circle.fill")
                .foregroundStyle(.yellow)
                .overlay{
                    Text("C")
                        .font(.caption2)
                        .fontWeight(.black)
                        .foregroundColor(.orange)
                }
            
            Text("\(coinManager.balance)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.black.opacity(0.35))
        .clipShape(Capsule())
    }
}
