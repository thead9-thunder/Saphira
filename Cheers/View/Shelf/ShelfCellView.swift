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

    @State private var activeSheet: ShelfModView.Mode?
    
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
        .shelfModSheet(activeSheet: $activeSheet)
    }

    @ViewBuilder
    var contextMenu: some View {
        Button(action: {
            activeSheet = .edit(shelf)
        }) {
            Label("Edit", systemImage: "pencil")
        }

        Button(role: .destructive, action: {
            shelf.delete()
        }) {
            Label("Delete", systemImage: "trash")
        }
    }
}
