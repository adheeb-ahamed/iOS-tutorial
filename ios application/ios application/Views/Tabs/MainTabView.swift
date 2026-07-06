//
//  MainTabView.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

// THIS IS THE MAIN TAB VIEW THAT IS ON THE BOTTOM OF THE APP

import SwiftUI

struct MainTabView: View {
    
    
    var body: some View {
        
        TabView {
            NavigationStack{
                MainView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            
            NavigationStack{
                StatView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            
            
            NavigationStack{
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }
            
            
            NavigationStack{
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            
            
        }
        
        
        
        
    }
}
