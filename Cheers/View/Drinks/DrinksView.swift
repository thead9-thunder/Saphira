//
//  DrinksView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct DrinksView: View {
    @Query private var drinks: [Drink]
    @Query private var latestTastings: [Tasting]

    @State private var isDrinkModPresented: DrinkModView.Mode?

    private var pinnedDrinks: [Drink] { drinks.filter { $0.isPinned } }

    private var icon: Icon
    private var unavailableTitle: String
    private var unavailableDescription: String

    init(config: Config) {
        self._drinks = config.drinks
        self._latestTastings = config.latestTastings
        self.icon = config.icon
        self.unavailableTitle = config.unavailableTitle
        self.unavailableDescription = config.unavailableDescription
    }

    var body: some View {
        Group {
            if drinks.isEmpty {
                emptyStateView
            } else {
                List {
                    Section("Statistics") {
                        DrinksStatsCard(drinks: _drinks, icon: icon)
                    }

                    if latestTastings.count != 0 {
                        Section("Latest Log Entries") {
                            TastingsReLogCard(tastings: _latestTastings)
                        }
                    }

                    if !pinnedDrinks.isEmpty {
                        Section {
                            ForEach(pinnedDrinks) { drink in
                                NavigationLink(value: NavigationDestination.drink(drink)) {
                                    DrinkCellView(drink: drink)
                                }
                            }
                        } header: {
                            Label("Pinned", systemImage: "pin")
                        }
                    }

                    Section("Drinks") {
                        ForEach(drinks) { drink in
                            NavigationLink(value: NavigationDestination.drink(drink)) {
                                DrinkCellView(drink: drink)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            IconLabel(unavailableTitle, icon: icon)
        } description: {
            Text(unavailableDescription)
        }
    }
}

extension DrinksView {
    struct Config {
        var drinks: Query<Drink, Array<Drink>>
        var latestTastings: Query<Tasting, Array<Tasting>>
        var icon: Icon
        var unavailableTitle: String
        var unavailableDescription: String
    }
}

struct FavoritesView: View {
    var body: some View {
        DrinksView(config: favoritesConfig)
            .navigationBarTitle("Favorites")
            .searchable(searchMode: .drinks(Drink.favorites))
            .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
    }
}

extension FavoritesView {
    var favoritesConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.favorites),
            latestTastings: Query(Tasting.forFavorites(limit: 10)),
            icon: .sfSymbol("heart.fill"),
            unavailableTitle: "No Favorites",
            unavailableDescription: "On a drink's page you can mark it as a favorite"
        )
    }
}

struct InStockView: View {
    var body: some View {
        DrinksView(config: inStockConfig)
            .searchable(searchMode: .drinks(Drink.inStock))
            .navigationBarTitle("In Stock")
            .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
    }
}

extension InStockView {
    var inStockConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.inStock),
            latestTastings: Query(Tasting.forInStock(limit: 10)),
            icon: .sfSymbol("checkmark.circle.fill"),
            unavailableTitle: "Nothing In Stock",
            unavailableDescription: "On a drink's page you can mark it as in stock"
        )
    }
}
