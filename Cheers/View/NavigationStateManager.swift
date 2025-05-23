//
//  NavigationStateManager.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var selectedShelf: Shelf? {
        // Needed because sometimes selectedDrink would be set programmaticaly and then when selectedShelf would change it would auto navigate to the previously set selectedDrink
        willSet {
            selectedDrink = nil
        }
    }
    @Published var selectedDrink: Drink?
    @Published var navigationPath = NavigationPath()

    func navigate(to shelf: Shelf) {
        selectedShelf = shelf
    }

    func navigate(to drink: Drink) {
        if let shelf = drink.shelf {
            navigate(to: shelf)
        }
        selectedDrink = drink
    }

    func clearSelection() {
        selectedShelf = nil
        selectedDrink = nil
    }
}

// MARK: - Environment Key Definition
private struct NavigationStateManagerKey: EnvironmentKey {
    static let defaultValue = NavigationStateManager()
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    var navigationState: NavigationStateManager {
        get { self[NavigationStateManagerKey.self] }
        set { self[NavigationStateManagerKey.self] = newValue }
    }
}

// MARK: - View Extension for easier access
extension View {
    func withNavigationState(_ navigationState: NavigationStateManager) -> some View {
        self.environment(\.navigationState, navigationState)
    }
}
