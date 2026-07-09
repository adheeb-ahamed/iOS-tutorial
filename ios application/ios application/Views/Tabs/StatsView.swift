//
//  StatView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import SwiftUI
import Charts

struct StatsView: View {
    
//    @StateObject var manager = GameSessionManager.shared
    
    @StateObject private var vm = StatViewModel()
    
    @ObservedObject var manager : GameSessionManager
    
    
    var body: some View {
        
        ScrollView {
            
            ZStack{
                Color(uiColor: .systemGroupedBackground) // Or use a tiled background Image asset
                .ignoresSafeArea()
                
                
                VStack (spacing : 20){
                    
                    Text ("Game Statistics")
                        .font(Font.largeTitle.bold())

                    HStack {
                                        
                        MetricCard(
                            title:"Total Games",
                            value:"\(vm.totalGames)"
                        )
                        
                        MetricCard(
                            title:"Highest Score",
                            value:"\(vm.highestScore)"
                        )
                    }
                    .padding()
                    
                    
                    chartSection
                        .padding()
                                    
                                    
                    
                    
                    ForEach(manager.sessions.sorted { $0.timestamp > $1.timestamp }) { session in
                        
                        VStack(alignment: .leading) {
                            
                            SessionCard(session: session)
                                    .padding(.horizontal)
                            
                        }
                        .padding()
                    } //end of For Each
                    
                    
                    
                }
                
            }
            .onAppear{
                print("Stats loaded:", manager.sessions.count)
                vm.calculateStats(from: manager.sessions)
            }
            }
            
            
        
        
    } //End of body
}


// This is for the bar chart

extension StatsView {
    var chartSection : some View {
        
        VStack(alignment: .leading) {
            
            Text ("High Score By Game ")
                .font(.headline)
            
            
            Chart(vm.stats) { item in
                
                    BarMark(
                        x : .value(
                            "Game",
                            item.mode.rawValue
                        ),
                        
                        y: .value(
                            "Score",
                            item.highscore
                            
                        )
                    )
                    .foregroundStyle(item.mode.color.opacity(0.85))
            }
            .frame(height: 250)
            
        }
    }
}

struct MetricCard: View {
    
    var title:String
    var value:String
    
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .font(.caption)
            
            Text(value)
                .font(.title)
                .bold()
            
        }
        .frame(maxWidth:.infinity)
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius:15
            )
            .fill(.gray.opacity(0.2))
        )
    }
}

struct SessionCard: View {
    
    let session: GameSessionModel
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            
            HStack {
                
                Text(session.mode.rawValue)
                    .font(.headline)
                
                
                Spacer()
                
                
                Circle()
                    .fill(session.mode.color)
                    .frame(width: 15, height: 15)
            }
            
            
            Divider()
            
            
            HStack {
                
                Text("Score")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(session.score)")
                    .bold()
            }
            
            
            HStack {
                
                Text("Last Played")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(
                    session.timestamp,
                    style: .relative
                )
            }
            
            
            HStack {
                
                Text("Date")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(
                    session.timestamp.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.15))
        )
    }
}
