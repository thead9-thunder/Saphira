//
//  ShelfCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShelfCellView: View {
    var shelf: Shelf

    @Query private var drinks: [Drink]

    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var showDeleteConfirmation = false

    init(shelf: Shelf) {
        self.shelf = shelf
        self._drinks = Query(Drink.on(shelf: shelf))
    }

    var body: some View {
        HStack {
            Label(shelf.name, systemImage: "square.stack.3d.up")
                .font(.body)
            
            Spacer()
            
            Text("\(drinks.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .clipShape(Capsule())
        }
        .contentShape(Rectangle())
        .contextMenu { contextMenu }
        .swipeActions(edge: .leading) {
            pinButton
        }
        .swipeActions(edge: .trailing) {
            addDrinkButton
            deleteButton
            infoButton
        }
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
        .confirmationDialog("Delete Shelf?", isPresented: $showDeleteConfirmation) {
            Button("Delete Shelf", role: .destructive) {
                shelf.delete()
            }
        } message: {
            Text("Are you sure you want to delete this shelf?\n\nThis will also delete all of its drinks and associated tastings.\n\nThis action cannot be undone.")
        }
    }

    @ViewBuilder
    var contextMenu: some View {
        infoButton
        pinButton
        addDrinkButton

        Divider()

        deleteButton
    }

    var pinButton: some View {
        Button {
            shelf.isPinned.toggle()
        } label: {
            Label(
                shelf.isPinned ? "Unpin shelf" : "Pin shelf",
                systemImage: shelf.isPinned ? "pin.slash" : "pin"
            )
        }
        .tint(.yellow)
    }

    var infoButton: some View {
        Button {
            isShelfModPresented = .edit(shelf)
        } label: {
            Label("Info", systemImage: "info")
        }
    }

    var addDrinkButton: some View {
        Button {
            isDrinkModPresented = .add(DrinkModView.Config(shelf: shelf))
        } label: {
            Label("Add Drink", systemImage: "plus")
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
