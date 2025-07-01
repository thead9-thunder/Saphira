//
//  NavigationDestination.swift
//  Cheers
//
//  Created by Thomas Headley on 6/3/25.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case favorites
    case inStock
    case brands
    case brand(Brand)
    case drink(Drink)
    case shelf(Shelf)

    @ViewBuilder
    static func navigationDestinationView(_ destination: NavigationDestination?) -> some View {
        switch destination {
        case .favorites:
            FavoritesView()
        case .inStock:
            InStockView()
        case .brands:
            BrandsView()
        case .brand(let brand):
            BrandView(brand: brand)
        case .drink(let drink):
            DrinkView(drink: drink)
        case .shelf(let shelf):
            ShelfView(shelf: shelf)
        default:
            ContentUnavailableView(
                "No Item Selected",
                systemImage: "cup.and.saucer",
                description: Text("Please select an item")
            )
        }
    }
}

struct NavigationState {
    var selectedDestination: Binding<NavigationDestination?>
    var detailPath: Binding<[NavigationDestination]>
    
    func navigate(to destination: NavigationDestination) {
        if selectedDestination.wrappedValue == nil {
            selectedDestination.wrappedValue = destination
        } else {
            detailPath.wrappedValue.append(destination)
        }
    }
}

private struct NavigationStateKey: EnvironmentKey {
    static let defaultValue = NavigationState(
        selectedDestination: .constant(nil),
        detailPath: .constant([])
    )
}

extension EnvironmentValues {
    var navigationState: NavigationState {
        get { self[NavigationStateKey.self] }
        set { self[NavigationStateKey.self] = newValue }
    }
}

extension View {
    func navigationState(
        selectedDestination: Binding<NavigationDestination?>,
        detailPath: Binding<[NavigationDestination]>
    ) -> some View {
        environment(\.navigationState, NavigationState(
            selectedDestination: selectedDestination,
            detailPath: detailPath
        ))
    }
}
