//
//  CheersView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct CheersView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var toastManager = ToastManager.shared
    
    @State var selectedDestination: NavigationDestination?
    @State var detailPath: [NavigationDestination] = []
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedDestination)
                .navigationTitle(Cheers.appName)
        } detail: {
            NavigationStack(path: $detailPath) {
                NavigationDestination.navigationDestinationView(selectedDestination)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        NavigationDestination.navigationDestinationView(destination)
                    }
            }
        }
        .navigationState(selectedDestination: $selectedDestination, detailPath: $detailPath)
        .overlay {
            ToastOverlay(toastManager: toastManager)
        }
    }
}
