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
                    if let drink = tasting.drink {
                        HStack(spacing: 15) {
                            DrinkReLogView(drink: drink)
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
}

struct DrinkReLogView: View {
    @Environment(\.navigationState) private var navigationState

    let drink: Drink

    @State private var isTastingModPresented: TastingModView.Mode?

    var body: some View {
        HStack(spacing: 15) {
            // TODO: Make this work for ShelfView
            Button {
                navigationState.navigate(to: drink)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.headline)

                    if let brand = drink.brand {
                        Text(brand.name)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .buttonStyle(.plain)

            Button {
                isTastingModPresented = .add(drink)
            } label: {
                Text("Log Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                    .shadow(radius: 2)
            }
        }
        .tastingModSheet(activeSheet: $isTastingModPresented)
    }
}

extension TastingsReLogCard {
    static private var defaultTitle = "Latest Tastings"
}
