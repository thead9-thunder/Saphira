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
    @Environment(\.navigationState) private var navigationState
    private var selectedDrinkBinding: Binding<Drink?> {
        Binding<Drink?>(
            get: { navigationState.selectedDrink },
            set: { navigationState.selectedDrink = $0 }
        )
    }
    
    @Query private var drinks: [Drink]
    let shelf: Shelf

    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?
    
    init(shelf: Shelf) {
        self.shelf = shelf
        self._drinks = Query(Drink.on(shelf: shelf))
    }

    var body: some View {
        Group {
            if drinks.isEmpty {
                emptyStateView
            } else {
                List(selection: selectedDrinkBinding) {
                    Section {
                        ShelfStatsCard(drinks: _drinks)
                    }

                    DrinksView(drinks: _drinks)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(shelf.name)
        .toolbar { toolbar }
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
        .floatingButton(label: "Add Drink", systemImage: "plus", position: .bottomCenter) {
            isDrinkModPresented = .add(DrinkModView.Config(shelf: shelf))
        }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShelfModPresented = .edit(shelf)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
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
