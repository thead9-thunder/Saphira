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
    @State private var isTastingSheetPresented: TastingModView.Mode?

    var body: some View {
        HStack(spacing: 16) {
            // TODO: Selectable icon
            Image(systemName: "wineglass.fill")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 44, height: 44)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())
            
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
        .contextMenu { contextMenu }
        .swipeActions(edge: .trailing) {
            Button {
                isTastingSheetPresented = .add(drink)
            } label: {
                Label("Add to Logbook", systemImage: "book.pages")
            }
            .tint(.accentColor)
        }
        .drinkModSheet(activeSheet: $activeSheet)
        .tastingModSheet(activeSheet: $isTastingSheetPresented)
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
