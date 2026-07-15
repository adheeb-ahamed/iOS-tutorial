//
//  ios_applicationApp.swift
//  ios application
//
//  Created by Student 3 on 2026-06-06.
//

import SwiftUI

@main
struct ios_applicationApp: App {
    
    @State var locationManager = LocationManager()
    
    @StateObject private var coinManager = CoinManager.shared
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(coinManager)
        }
    }
}

