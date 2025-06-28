//
//  DrinksStatsCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DrinksStatsCard: View {
    @Query var drinks: [Drink]

    init(drinks: FetchDescriptor<Drink>) {
        _drinks = Query(drinks)
    }

    init(drinks: Query<Drink, Array<Drink>>) {
        _drinks = drinks
    }

    var body: some View {
        HStack(spacing: 15) {
            StatView(
                value: "\(drinks.count)",
                label: "Drinks",
                systemImage: "wineglass"
            )
            .popAnimation(value: drinks.count)

            StatView(
                value: "\(totalTastings)",
                label: "Log Entries",
                systemImage: "book.pages"
            )
            .popAnimation(value: totalTastings)
        }
    }
    
    private var totalTastings: Int {
        drinks.reduce(0) { sum, drink in
            sum + (drink.tastings?.count ?? 0)
        }
    }
}
