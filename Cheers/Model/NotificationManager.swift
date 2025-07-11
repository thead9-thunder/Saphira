//
//  NotificationManager.swift
//  Cheers
//
//  Created by Thomas Headley on 7/11/25.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var pendingNotifications: [UNNotificationRequest] = []
    
    static let shared = NotificationManager()
    
    private init() {
        refreshAuthorizationStatus()
    }
    
    func refreshAuthorizationStatus() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func refreshPendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotifications = requests
            }
        }
    }
    
    func requestAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            notificationCenter.getNotificationSettings { settings in
                DispatchQueue.main.async {
                    self?.authorizationStatus = settings.authorizationStatus
                }
                
                if !settings.authorizationStatus.isDenied {
                    // Schedule at 7 PM today (or tomorrow if past 7 PM)
                    var components = DateComponents()
                    components.hour = 19
                    components.minute = 0
                    let calendar = Calendar.current
                    let now = Date()
                    let sevenPM = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) ?? now
                    self?.scheduleDailyReminder(at: sevenPM)
                }
            }
        }
    }
    
    func deleteNotification(identifier: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        refreshPendingNotifications()
    }
    
    private func scheduleNotification(
        title: String,
        body: String,
        at date: Date,
        repeats: Bool = false,
        identifier: String = UUID().uuidString
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshPendingNotifications()
            }
        }
        
        refreshPendingNotifications()
    }
}

extension NotificationManager {
    static let dailyTitle = "Friendly Reminder"
    static let dailyBody = "Remember to log your drinks"
    static let dailyID = "dailyNotification"
    
    var pendingDailyNotifications: [UNNotificationRequest] {
        pendingNotifications
            .filter { $0.identifier.contains(NotificationManager.dailyID) }
            .sorted { lhs, rhs in
                let lhsDate = (lhs.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
                let rhsDate = (rhs.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
                switch (lhsDate, rhsDate) {
                case let (l?, r?):
                    let lComp = Calendar.current.dateComponents([.hour, .minute], from: l)
                    let rComp = Calendar.current.dateComponents([.hour, .minute], from: r)
                    if lComp.hour == rComp.hour {
                        return (lComp.minute ?? 0) < (rComp.minute ?? 0)
                    }
                    return (lComp.hour ?? 0) < (rComp.hour ?? 0)
                case (nil, nil):
                    return lhs.identifier < rhs.identifier
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                }
            }
    }
    
    func scheduleDailyReminder(
        title: String = NotificationManager.dailyTitle,
        at date: Date? = nil,
        identifier: String? = nil
    ) {
        let calendar = Calendar.current
        let now = Date()
        let nextDate: Date
        if let date = date {
            let selectedComponents = calendar.dateComponents([.hour, .minute], from: date)
            var computedDate = calendar.nextDate(after: now, matching: selectedComponents, matchingPolicy: .nextTime) ?? now
            // If the selected time is now, schedule for tomorrow
            if calendar.isDate(computedDate, equalTo: now, toGranularity: .minute) {
                computedDate = calendar.date(byAdding: .day, value: 1, to: computedDate) ?? computedDate
            }
            nextDate = computedDate
        } else {
            // Default to 7 PM
            var components = DateComponents()
            components.hour = 19
            components.minute = 0
            nextDate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) ?? now
        }
        scheduleNotification(
            title: title,
            body: NotificationManager.dailyBody,
            at: nextDate,
            repeats: true,
            identifier: identifier ?? NotificationManager.dailyID + UUID().uuidString
        )
    }
}

extension UNAuthorizationStatus {
    var isDenied: Bool {
        self == .denied
    }
}

