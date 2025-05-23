//
//  TastingsStatsCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TastingsStatsCard: View {
    @Query var tastings: [Tasting]
    @State private var scale: CGFloat = 1.0

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    init(tastings: Query<Tasting, Array<Tasting>>) {
        _tastings = tastings
    }

    var body: some View {
        HStack(spacing: 15) {
            StatView(
                value: "\(tastings.count)",
                label: "Tastings",
                systemImage: "book.pages"
            )
            .popAnimation(value: tastings.count)

            if let firstTasting = tastings.last {
                StatView(
                    value: firstTasting.date.formatted(date: .abbreviated, time: .omitted),
                    label: "First Tasted",
                    systemImage: "calendar"
                )
                .popAnimation(value: tastings.last)
            }

            if let lastTasting = tastings.first {
                StatView(
                    value: lastTasting.date.formatted(date: .abbreviated, time: .omitted),
                    label: "Last Tasted",
                    systemImage: "calendar.badge.clock"
                )
                .popAnimation(value: tastings.first)
            }
        }
    }
}
