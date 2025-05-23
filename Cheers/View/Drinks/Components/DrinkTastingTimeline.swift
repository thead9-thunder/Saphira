//
//  DrinkTastingTimeline.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DrinkTastingTimeline: View {
    @Query var tastings: [Tasting]

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    init(tastings: Query<Tasting, Array<Tasting>>) {
        _tastings = tastings
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Logbook")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if tastings.isEmpty {
                ContentUnavailableView(
                    "No Tastings",
                    systemImage: "book.pages",
                    description: Text("Add your first tasting using the button below")
                )
            } else {
                ForEach(tastings) { tasting in
                    TastingCell(tasting: tasting)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
