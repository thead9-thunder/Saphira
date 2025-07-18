//
//  ShelfView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/20/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShelfView: View {
    let shelf: Shelf

    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?

    var body: some View {
        DrinksView(config: drinksViewConfig)
            .navigationTitle(shelf.name)
            .searchable(searchMode: .shelf(shelf))
            .toolbar { toolbar }
            .shelfModSheet(activeSheet: $isShelfModPresented)
            .drinkModSheet(activeSheet: $isDrinkModPresented)
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShelfModPresented = .edit(shelf)
            } label: {
                Label("Info", systemImage: "info")
            }
        }

        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarSpacer(placement: .bottomBar)
        ToolbarItem(placement: .bottomBar) {
            Button {
                isDrinkModPresented = .add(DrinkModView.Config(shelf: shelf))
            } label: {
                Label("Add Drink", systemImage: "plus")
            }
        }
    }
}

extension ShelfView {
    var drinksViewConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.on(shelf: shelf)),
            latestTastings: Query(Tasting.forShelf(shelf, limit: 10)),
            icon: shelf.icon,
            unavailableTitle: "No Drinks",
            unavailableDescription: "Add your first drink on this shelf using the button below"
        )
    }
}
