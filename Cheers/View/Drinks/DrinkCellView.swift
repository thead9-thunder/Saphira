//
//  DrinkCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI

struct DrinkCellView: View {
    var drink: Drink

    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var isTastingModPresented: TastingModView.Mode?
    @State private var showDeleteConfirmation = false

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
        .swipeActions(edge: .leading) {
            pinButton
        }
        .swipeActions(edge: .trailing) {
            addTastingButton
            deleteButton
            infoButton
        }
        .drinkModSheet(activeSheet: $isDrinkModPresented)
        .tastingModSheet(activeSheet: $isTastingModPresented)
        .confirmationDialog("Delete Drink?", isPresented: $showDeleteConfirmation) {
            Button("Delete Drink", role: .destructive) {
                drink.delete()
            }
        } message: {
            Text("Are you sure you want to delete this drink?\n\nThis will also delete all of its associated tastings.\n\nThis action cannot be undone.")
        }
    }

    @ViewBuilder
    var contextMenu: some View {
        infoButton
        pinButton
        addTastingButton

        Divider()

        deleteButton
    }

    var pinButton: some View {
        Button {
            drink.isPinned.toggle()
        } label: {
            Label(
                drink.isPinned ? "Unpin drink" : "Pin drink",
                systemImage: drink.isPinned ? "pin.slash" : "pin"
            )
        }
        .tint(.yellow)
    }

    var infoButton: some View {
        Button {
            isDrinkModPresented = .edit(drink)
        } label: {
            Label("Info", systemImage: "info")
        }
    }

    var addTastingButton: some View {
        Button {
            isTastingModPresented = .add(drink)
        } label: {
            Label("Add to Logbook", systemImage: "book.pages")
        }
        .tint(.accentColor)
    }

    var deleteButton: some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red)
    }
}

#Preview {
    DrinkCellView(drink: Drink.sampleData.first!)
        .modelContainer(SampleData.shared.modelContainer)
}
