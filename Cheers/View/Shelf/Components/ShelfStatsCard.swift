//
//  ShelfStatsCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShelfStatsCard: View {
    @Query var drinks: [Drink]

    init(drinks: FetchDescriptor<Drink>) {
        _drinks = Query(drinks)
    }

    init(drinks: Query<Drink, Array<Drink>>) {
        _drinks = drinks
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 15) {
                StatView(
                    value: "\(drinks.count)",
                    label: "Drinks",
                    systemImage: "wineglass"
                )
                
                StatView(
                    value: "\(totalTastings)",
                    label: "Tastings",
                    systemImage: "book.pages"
                )
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var totalTastings: Int {
        drinks.reduce(0) { sum, drink in
            sum + (drink.tastings?.count ?? 0)
        }
    }
}
