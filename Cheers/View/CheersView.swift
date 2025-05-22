//
//  CheersView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct CheersView: View {
    @StateObject private var navigationState = NavigationStateManager()

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationTitle("Cheers")
        } content: {
            if let shelf = navigationState.selectedShelf {
                ShelfView(shelf: shelf)
            }
        } detail: {
            if let drink = navigationState.selectedDrink {
                DrinkView(drink: drink)
            }
        }
        .withNavigationState(navigationState)
    }
}

#Preview {
    CheersView()
}
