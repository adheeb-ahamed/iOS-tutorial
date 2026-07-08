//
//  SettingsViewModel.swift
//  ios application
//
//  Created by student5 on 2026-07-08.
//'
import Foundation
import Combine


class SettingsViewModel: ObservableObject {

    @Published var reminderTime = Date()

    func saveReminder(time : Date) {

        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        NotificationManager.shared.scheduleDailyReminder(
            hour: components.hour ?? 9,
            minute: components.minute ?? 0
        
        )
    }
    
    
}
