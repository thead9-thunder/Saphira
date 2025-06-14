//
//  BrandCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct BrandCellView: View {
    var brand: Brand

    @Query private var drinks: [Drink]

    @State private var isBrandModPresented: BrandModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var showDeleteConfirmation = false

    init(brand: Brand) {
        self.brand = brand
        self._drinks = Query(Drink.by(brand: brand))
    }

    var body: some View {
        HStack {
            Text(brand.name)

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
        .swipeActions(edge: .trailing) {
            addDrinkButton
            deleteButton
            infoButton
        }
        .brandModSheet(activeSheet: $isBrandModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
        .confirmationDialog("Delete Brand?", isPresented: $showDeleteConfirmation) {
            Button("Delete Brand", role: .destructive) {
                brand.delete()
            }
        } message: {
            Text("Are you sure you want to delete this brand?\n\nThis action cannot be undone.")
        }
    }

    @ViewBuilder
    var contextMenu: some View {
        infoButton
        addDrinkButton

        Divider()

        deleteButton
    }

    var infoButton: some View {
        Button {
            isBrandModPresented = .edit(brand)
        } label: {
            Label("Info", systemImage: "info")
        }
    }

    var addDrinkButton: some View {
        Button {
            isDrinkModPresented = .add(DrinkModView.Config(brand: brand))
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
