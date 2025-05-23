//
//  DrinkHeaderCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI

struct DrinkHeaderCard: View {
    var drink: Drink

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let brand = drink.brand {
                // TODO: Make this a NavigationLink
                Label {
                    Text(brand.name)
                        .font(.headline)
                } icon: {
                    Image(systemName: "storefront.fill")
                        .foregroundStyle(.secondary)
                }
            }

            if let shelf = drink.shelf {
                Label {
                    Group {
                        if let cabinet = shelf.cabinet {
                            Text("\(shelf.name) in ") +
                            Text(cabinet.name).bold()
                        } else {
                            Text(shelf.name)
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.8))
                } icon: {
                    Image(systemName: "cabinet.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
