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

    @State private var activeSheet: BrandModView.Mode?

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
        .brandModSheet(activeSheet: $activeSheet)
    }

    @ViewBuilder
    var contextMenu: some View {
        Button(action: {
            activeSheet = .edit(brand)
        }) {
            Label("Edit", systemImage: "pencil")
        }

        Button(role: .destructive, action: {
            brand.delete()
        }) {
            Label("Delete", systemImage: "trash")
        }
    }
}
