//
//  CheersView2.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case favorites
    case inStock
    case brand(Brand)
    case drink(Drink)
    case shelf(Shelf)
}

struct CheersView2: View {
    @State var selectedDestination: NavigationDestination?
    @State var detailPath: [NavigationDestination] = []

    var body: some View {
        NavigationSplitView {
            SidebarView2(selectedItem: $selectedDestination)
                .navigationTitle("Cheers")
        } detail: {
            NavigationStack(path: $detailPath) {
                navigationDestinationView(selectedDestination)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        navigationDestinationView(destination)
                    }
            }
        }
    }

    @ViewBuilder
    func navigationDestinationView(_ destination: NavigationDestination?) -> some View {
        switch destination {
        case .favorites:
            FavoritesView()
        case .inStock:
            InStockView()
        case .brand(let brand):
            BrandView(brand: brand)
        case .drink(let drink):
            DrinkView(drink: drink)
        case .shelf(let shelf):
            ShelfView(shelf: shelf)
        default:
            Text("Welcome to Cheers!")
        }
    }
}
