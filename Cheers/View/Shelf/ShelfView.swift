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

        ToolbarItem(placement: .bottomBar) {
            Button {
                isDrinkModPresented = .add(DrinkModView.Config(shelf: shelf))
            } label: {
                Label("Add Drink", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Drinks", systemImage: "wineglass")
        } description: {
            Text("Add your first drink using the button below")
        }
    }

    private var noSearchResultsView: some View {
        ContentUnavailableView {
            Label("No Results", systemImage: "magnifyingglass")
        } description: {
            Text("Try adjusting your search term")
        }
    }
}

extension ShelfView {
    var drinksViewConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.on(shelf: shelf)),
            latestTastings: Query(Tasting.forShelf(shelf, limit: 10))
        )
    }
}
