//
//  BrandCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI

struct BrandCellView: View {
    var brand: Brand

    @State private var activeSheet: BrandModView.Mode?

    var body: some View {
        Text(brand.name)
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
