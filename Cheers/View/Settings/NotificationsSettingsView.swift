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
    var body: some View {
        VStack {
            Form {
                notificationSettingsSection
            }
        }
        .navigationTitle("Notifications")
    }
    
    private var notificationSettingsSection: some View {
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
            Text("Notification Settings")
        }
    }
    
    private var reminderSettingsSection: some View {
        Section {
            
        } header: {
            Text("Reminders")
        }
    }
}
