//
//  SettingsView.swift
//  ios application
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    
    @State private var reminderTime = Date()
    @State private var notificationsEnabled = false
    @State private var showingEraseAlert = false
    
    @AppStorage("challengeHour") private var challengeHour = 9
    @AppStorage("challengeMinute") private var challengeMinute = 0
    
    var body: some View {
        
        NavigationStack {
            
            Form {	
                
                Section {
                    
                    Toggle(
                        "Daily Challenge Reminder",
                        isOn: $notificationsEnabled
                    )
                    .onChange(of: notificationsEnabled) {_, newValue in
                        
                        if newValue {
                            NotificationManager.shared.requestPermission()
                        }
                    }
                    
                } header: {
                    Text("Notifications")
                }
                
                
                Section {
                    
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    
                    Button {

                        let components = Calendar.current.dateComponents(
                            [.hour, .minute],
                            from: reminderTime
                        )

                        challengeHour = components.hour ?? 9
                        challengeMinute = components.minute ?? 0

                        NotificationManager.shared.scheduleDailyReminder(
                            hour: challengeHour,
                            minute: challengeMinute
                        )

                    } label: {

                        HStack {
                            Spacer()
                            Text("Save Reminder")
                                .bold()
                            Spacer()
                        }
                    }
                    
                    
                } header: {
                    Text("Daily Challenge")
                }
                
                Section {
                    Button(role: .destructive) {
                        showingEraseAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Erase All Data")
                                .bold()
                            Spacer()
                        }
                    }
                } header: {
                    Text("Danger Zone")
                }
            }
            .navigationTitle("Settings")
            .alert("Are you sure?", isPresented: $showingEraseAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Erase Everything", role: .destructive) {
                    eraseAllData()
                }
            } message: {
                Text("This will permanently delete all your game stats, high scores, and reset your settings. This action cannot be undone.")
            }
        }
    }
    
    private func eraseAllData() {
        // 1. Clear Game Sessions (resets Stats and Map)
        GameSessionManager.shared.clearSessions()
        
        // 2. Remove High Scores & Daily Challenge Completion
        UserDefaults.standard.removeObject(forKey: "lightItUpHighScore")
        UserDefaults.standard.removeObject(forKey: "TapGameHighScore")
        UserDefaults.standard.removeObject(forKey: "dailyChallengeCompleted")
        
        // 3. Reset Challenge Reminder Time
        UserDefaults.standard.removeObject(forKey: "challengeHour")
        UserDefaults.standard.removeObject(forKey: "challengeMinute")
        challengeHour = 9
        challengeMinute = 0
        reminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        
        // 4. Cancel pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notificationsEnabled = false
    }
}


#Preview {
    SettingsView()
}
