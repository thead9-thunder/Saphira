//
//  CheersApp.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import SwiftUI
import SwiftData

@main
struct CheersApp: App {
    var body: some Scene {
        WindowGroup {
            CheersView2()
        }
        .modelContainer(ModelUtilities.persistentModelContainer)
    }
}
