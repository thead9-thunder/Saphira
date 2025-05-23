//
//  DrinkStatsCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DrinkStatsCard: View {
    @Query var tastings: [Tasting]

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    init(tastings: Query<Tasting, Array<Tasting>>) {
        _tastings = tastings
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 15) {
                StatView(
                    value: "\(tastings.count)",
                    label: "Tastings",
                    systemImage: "book.pages"
                )

                if let firstTasting = tastings.last {
                    StatView(
                        value: firstTasting.date.formatted(date: .abbreviated, time: .omitted),
                        label: "First Tasted",
                        systemImage: "calendar"
                    )
                }

                if let lastTasting = tastings.first {
                    StatView(
                        value: lastTasting.date.formatted(date: .abbreviated, time: .omitted),
                        label: "Last Tasted",
                        systemImage: "calendar.badge.clock"
                    )
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
