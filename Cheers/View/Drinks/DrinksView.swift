//
//  DrinksView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct DrinksView: View {
    @Environment(\.navigationState) private var navigationState
    private var selectedDrinkBinding: Binding<Drink?> {
        Binding<Drink?>(
            get: { navigationState.selectedDrink },
            set: { navigationState.selectedDrink = $0 }
        )
    }

    @Query private var drinks: [Drink]
    @Query private var latestTastings: [Tasting]

    @State private var isDrinkModPresented: DrinkModView.Mode?

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
                List(selection: selectedDrinkBinding) {
                    Section("Statistics") {
                        DrinksStatsCard(drinks: _drinks)
                    }

                    if latestTastings.count != 0 {
                        Section("Latest Tastings") {
                            TastingsReLogCard(tastings: _latestTastings)
                        }
                    }

                    Section("Drinks") {
                        ForEach(drinks) { drink in
                            NavigationLink(value: drink) {
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
    var body: some View {
        DrinksView(config: favoritesConfig)
            .navigationBarTitle("Favorites")
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
