//
//  NotificationsSettingsView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import SwiftUI
import UIKit

struct NotificationsSettingsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        VStack {
            Form {
                notificationSettingsSection
                reminderSettingsSection
                    .disabled(notificationManager.authorizationStatus.isDenied)
                    .opacity(notificationManager.authorizationStatus.isDenied ? 0.3 : 1)
            }
        }
        .navigationTitle("Notifications")
        .task { beforeLoad() }
    }
    
    private func beforeLoad() {
        notificationManager.refreshPendingNotifications()
        notificationManager.refreshAuthorizationStatus()
        switch notificationManager.authorizationStatus {
        case .notDetermined:
            notificationManager.requestAuthorization()
        default:
            break
        }
    }
    
    @ViewBuilder
    private var notificationSettingsSection: some View {
        switch notificationManager.authorizationStatus {
        case .notDetermined:
            Section {
                Button {
                    notificationManager.requestAuthorization()
                } label: {
                    Text("Allow Notifications")
                }
            } header: {
                Text("Notification Settings")
            }
        case .denied:
            Section {
                Button {
                    if let notifcationSettingsURL = URL(string: UIApplication.openNotificationSettingsURLString) {
                        UIApplication.shared.open(notifcationSettingsURL)
                    }
                } label: {
                    HStack {
                        Text("Open Notification Settings")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("Please grant permission for notifications in Settings")
            }
        case .authorized, .provisional, .ephemeral:
            EmptyView()
        default:
            EmptyView()
        }
        
    }
    
    private var reminderSettingsSection: some View {
        Section {
            if notificationManager.pendingDailyNotifications.isEmpty {
                Text("No daily reminders")
                    .foregroundColor(.secondary)
            } else {
                ForEach(notificationManager.pendingDailyNotifications, id: \.identifier) { request in
                    NotificationRowView(request: request)
                }
            }
            
            Button {
                notificationManager.scheduleDailyReminder(at: .now)
            } label: {
                Label("Add Daily Reminder", systemImage: "plus")
            }
        } header: {
            Text("Daily Reminders")
        }
    }
}

struct NotificationRowView: View {
    let request: UNNotificationRequest
    @StateObject private var notificationManager = NotificationManager.shared
    
    @State private var editedTitle: String
    @State private var editedTime: Date
    
    init(request: UNNotificationRequest) {
        self.request = request
        _editedTitle = State(initialValue: request.content.title)
        if let trigger = request.trigger as? UNCalendarNotificationTrigger,
           let nextTriggerDate = trigger.nextTriggerDate() {
            _editedTime = State(initialValue: nextTriggerDate)
        } else {
            _editedTime = State(initialValue: Date())
        }
    }
    
    var body: some View {
        HStack {
            TextField("Title", text: $editedTitle, onEditingChanged: { _ in }, onCommit: {
                updateNotification()
            })
            
            DatePicker("Time", selection: $editedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .onChange(of: editedTime) {
                    updateNotification()
                }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                notificationManager.deleteNotification(identifier: request.identifier)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func updateNotification() {
        notificationManager.scheduleDailyReminder(title: editedTitle, at: editedTime, identifier: request.identifier)
    }
}
