//
//  SettingsView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {

    var body: some View {
        VStack {
            List {
                NavigationLink(destination: NotificationsSettingsView()) {
                    Label("Notifications", systemImage: "app.badge")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
