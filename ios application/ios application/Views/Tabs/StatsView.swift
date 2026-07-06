//
//  StatView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import SwiftUI

struct StatsView: View {
    
    @StateObject var manager = GameSessionManager.shared
    
    
    var body: some View {
        
        List(manager.sessions) { session in
            
            VStack (alignment: .leading){
                
                Text (session.mode.rawValue)
                
                Text ("Score : \(session.score)")
                
                Text (session.timestamp.formatted())
                
            }
            
        } //end of list
        
    } //End of body
}
