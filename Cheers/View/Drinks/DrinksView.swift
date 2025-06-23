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

    private var unavailableLabel: String
    private var unavailableSystemImage: String
    private var unavailableDescription: String

    init(config: Config) {
        self._drinks = config.drinks
        self._latestTastings = config.latestTastings
        self.unavailableLabel = config.unavailableLabel
        self.unavailableSystemImage = config.unavailableSystemImage
        self.unavailableDescription = config.unavailableDescription
    }

    var body: some View {
        Group {
            if drinks.isEmpty {
                emptyStateView
            } else {
                List {
                    Section("Statistics") {
                        DrinksStatsCard(drinks: _drinks)
                    }

                    if latestTastings.count != 0 {
                        Section("Latest Tastings") {
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
            Label(unavailableLabel, systemImage: unavailableSystemImage)
        } description: {
            Text(unavailableDescription)
        }
    }
}

extension DrinksView {
    struct Config {
        var drinks: Query<Drink, Array<Drink>>
        var latestTastings: Query<Tasting, Array<Tasting>>
        var unavailableLabel: String = "No Drinks"
        var unavailableSystemImage: String = "wineglass"
        var unavailableDescription: String = "Add your first drink using the button below"
    }
}

struct FavoritesView: View {
    @State private var searchText = ""
    @State private var isSearchPresented = false
    
    var body: some View {
        VStack {
            if isSearchPresented {
                SearchView(searchText: searchText, mode: .drinks(Drink.favorites))
            } else {
                DrinksView(config: favoritesConfig)
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        .navigationBarTitle("Favorites")
        .searchable(text: $searchText, isPresented: $isSearchPresented)
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
            unavailableLabel: "No Favorites",
            unavailableSystemImage: "star.fill",
            unavailableDescription: "On a drink's page you can mark it as a favorite"
        )
    }
}

struct InStockView: View {
    var body: some View {
        DrinksView(config: inStockConfig)
            .navigationBarTitle("In Stock")
    }
}

extension InStockView {
    var inStockConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.inStock),
            latestTastings: Query(Tasting.forInStock(limit: 10)),
            unavailableLabel: "Nothing In Stock",
            unavailableSystemImage: "circle.slash",
            unavailableDescription: "On a drink's page you can mark it as in stock"
        )
    }
}
