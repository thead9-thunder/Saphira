//
//  TastingsReLogCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TastingsReLogCard: View {
    @Query var tastings: [Tasting]

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    init(tastings: Query<Tasting, Array<Tasting>>) {
        _tastings = tastings
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                ForEach(Array(tastings.enumerated()), id: \.element.id) { index, tasting in
                    HStack(spacing: 15) {
                        DrinkReLogView(tasting: tasting)
                        if index < tastings.count - 1 {
                            Divider()
                                .padding(.vertical)
                        }
                    }
                }
            }
        }
    }
}

struct DrinkReLogView: View {
    let tasting: Tasting

    @State private var isTastingModPresented: TastingModView.Mode?

    var body: some View {
        if let drink = tasting.drink {
            HStack(spacing: 15) {
                NavigationLink(value: NavigationDestination.drink(drink)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drink.name)
                            .font(.headline)
                        
                        if let brand = drink.brand {
                            Text(brand.name)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        Text("\(tasting.date, style: .relative) ago")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    isTastingModPresented = .add(drink)
                } label: {
                    Text("Log Again")
                }
                .buttonStyle(.borderedProminent)
            }
            .tastingModSheet(activeSheet: $isTastingModPresented)
        }
    }
}

extension TastingsReLogCard {
    static private var defaultTitle = "Latest Tastings"
}
