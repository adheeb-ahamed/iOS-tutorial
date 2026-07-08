//
//  notificationManager.swift
//  ios application
//
//  Created by student5 on 2026-07-08.
//

import UserNotifications
import Foundation


class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if granted {
                    print("Permission granted")
                }
                else{
                    print("Permission not granted")
                }
            }
        
    } //End of request function
    
    
    func scheduleDailyReminder(hour : Int, minute : Int) {
        
        let content  = UNMutableNotificationContent()
        
        content .title = "Daily Reminder"
        content .body = "Your daily challenge is ready."
        content .sound = .default
        
        var date = DateComponents()
        
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyChallengeReminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error : \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled")
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
}


