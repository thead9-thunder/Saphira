//
//  CheersView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI



struct CheersView: View {
    @State var selectedDestination: NavigationDestination?
    @State var detailPath: [NavigationDestination] = []

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedDestination)
                .navigationTitle("Cheers")
        } detail: {
            NavigationStack(path: $detailPath) {
                NavigationDestination.navigationDestinationView(selectedDestination)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        NavigationDestination.navigationDestinationView(destination)
                    }
            }
        }
    }
}
