//
//  DrinkView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DrinkView: View {
    let drink: Drink
    @Query var tastings: [Tasting]

    @State private var isDrinkSheetPresented: DrinkModView.Mode?
    @State private var isTastingSheetPresented: TastingModView.Mode?

    init(drink: Drink) {
        self.drink = drink
        _tastings = Query(Tasting.forDrink(drink))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DrinkHeaderCard(drink: drink)
                DrinkStatsCard(tastings: tastings)
                // TODO: Make a card for meta data like rating, in stock, etc

                DrinkTastingTimeline(tastings: tastings)
            }
            .padding()
        }
        .navigationTitle(drink.name)
        .toolbar { toolbar }
        .background(Color(uiColor: .systemGroupedBackground))
        .drinkModSheet(activeSheet: $isDrinkSheetPresented)
        .tastingModSheet(activeSheet: $isTastingSheetPresented)
        .floatingButton(label: "Add to Logbook", systemImage: "book.pages", position: .bottomCenter) {
            isTastingSheetPresented = .add(drink)
        }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isDrinkSheetPresented = .edit(drink)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}
