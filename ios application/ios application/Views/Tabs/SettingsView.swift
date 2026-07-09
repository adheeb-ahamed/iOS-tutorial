//
//  SettingsView.swift
//  ios application
//

import SwiftUI

struct SettingsView: View {
    
    @State private var reminderTime = Date()
    @State private var notificationsEnabled = false
    
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
            }
            .navigationTitle("Settings")
        }
    }
}


#Preview {
    SettingsView()
}
