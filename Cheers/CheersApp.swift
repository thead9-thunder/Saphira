//
//  CheersApp.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import AppIntents
import SwiftUI
import SwiftData

@main
struct CheersApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            CheersView()
        }
        .modelContainer(ModelUtilities.persistentModelContainer)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                NotificationManager.shared.refreshAuthorizationStatus()
            }
        }
    }
}
