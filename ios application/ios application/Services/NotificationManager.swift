//
//  notificationManager.swift
//  ios application
//
//  Created by student5 on 2026-07-08.
//

import UserNotifications


class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if granted {
                    print("Permission granted")
                }else {
                    print("Permission not granted")
                }
            }
        
    }
}
