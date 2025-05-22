//
//  DrinkCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI

struct DrinkCellView: View {
    var drink: Drink

    @State private var activeSheet: DrinkModView.Mode?

    var body: some View {
        Text(drink.name)
            .contextMenu { contextMenu }
            .drinkModSheet(activeSheet: $activeSheet)
    }

    @ViewBuilder
    var contextMenu: some View {
        Button(action: {
            activeSheet = .edit(drink)
        }) {
            Label("Edit", systemImage: "pencil")
        }

        Button(role: .destructive, action: {
            drink.delete()
        }) {
            Label("Delete", systemImage: "trash")
        }
    }
}

#Preview {
    DrinkCellView(drink: Drink.sampleData.first!)
        .modelContainer(SampleData.shared.modelContainer)
}
