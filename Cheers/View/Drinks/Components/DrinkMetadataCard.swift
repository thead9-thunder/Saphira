//
//  DrinkMetadataCard.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DrinkMetadataCard: View {
    @Bindable var drink: Drink

    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                IconToggle(
                    label: "Favorite",
                    onIcon: "heart.fill",
                    offIcon: "heart.slash",
                    isOn: $drink.isFavorite
                )

                IconToggle(
                    label: "In Stock",
                    onIcon: "checkmark.circle.fill",
                    offIcon: "circle.slash",
                    isOn: $drink.isInStock
                )
            }
            
            if !drink.notes.isEmpty {
                Divider()

                GridRow {
                    Text(drink.notes)
                        .gridCellColumns(2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
