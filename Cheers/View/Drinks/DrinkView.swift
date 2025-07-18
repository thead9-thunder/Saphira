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
        List {
            Section {
                DrinkHeaderCard(drink: drink)
            } header : {
                EmptyView()
            }

            Section("Statistics") {
                TastingsStatsCard(tastings: _tastings)
            }

            Section("Logbook") {
                if tastings.isEmpty {
                    ContentUnavailableView(
                        "No Log Entries",
                        systemImage: "book.pages",
                        description: Text("Add your first log entry using the button below")
                    )
                } else {
                    TastingsTimeline(tastings: _tastings)
                }
            }
        }
        .navigationTitle(drink.name)
        .toolbar { toolbar }
        .background(Color(uiColor: .systemGroupedBackground))
        .drinkModSheet(activeSheet: $isDrinkSheetPresented)
        .tastingModSheet(activeSheet: $isTastingSheetPresented)
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isDrinkSheetPresented = .edit(drink)
            } label: {
                Label("Info", systemImage: "info")
            }
        }
        
        ToolbarItem(placement: .bottomBar) {
            Button {
                isTastingSheetPresented = .add(drink)
            } label: {
                Text("Add to Logbook")
                // Won't display both title and icon
//                Label("Add to Logbook", systemImage: "book.pages")
//                    .labelStyle(.titleAndIcon)
            }
        }
    }
}
