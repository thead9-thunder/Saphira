//
//  ShelfCellView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI

struct ShelfCellView: View {
    var shelf: Shelf

    @State private var activeSheet: ShelfModView.Mode?

    var body: some View {
        Text(shelf.name)
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
