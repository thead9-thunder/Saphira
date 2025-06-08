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
                systemImage: "wineglass",
                description: Text("Please select an item")
            )
        }
    }
}

private struct NavigationPathKey: EnvironmentKey {
    static let defaultValue: Binding<[NavigationDestination]> = .constant([])
}

extension EnvironmentValues {
    var navigationPath: Binding<[NavigationDestination]> {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}

extension View {
    func navigationPath(_ path: Binding<[NavigationDestination]>) -> some View {
        environment(\.navigationPath, path)
    }
}
