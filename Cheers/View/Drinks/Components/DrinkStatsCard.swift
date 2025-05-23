//
//  DrinkStatsCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI

struct DrinkStatsCard: View {
    var tastings: [Tasting]

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

// MARK: - Supporting Views
private struct StatView: View {
    let value: String
    let label: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.tint)

            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}

