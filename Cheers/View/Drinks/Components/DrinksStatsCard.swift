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
    let icon: Icon

    init(drinks: FetchDescriptor<Drink>, icon: Icon) {
        _drinks = Query(drinks)
        self.icon = icon
    }

    init(drinks: Query<Drink, Array<Drink>>, icon: Icon) {
        _drinks = drinks
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 15) {
            StatView(
                value: "\(drinks.count)",
                label: "Drinks",
                icon: icon
            )
            .popAnimation(value: drinks.count)

            StatView(
                value: "\(totalTastings)",
                label: "Log Entries",
                icon: .sfSymbol("book.pages")
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
