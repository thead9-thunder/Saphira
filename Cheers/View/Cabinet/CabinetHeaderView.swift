//
//  CabinetHeaderView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI

struct CabinetHeaderView: View {
    let cabinet: Cabinet

    @State private var isCabinetModPresented: CabinetModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack {
            IconLabel(cabinet.name, icon: cabinet.icon)
                .font(.title2)
                .foregroundStyle(Color(.label))

            Spacer()

            Menu {
                infoButton
                addShelfButton

                Divider()

                deleteButton
            } label: {
                Label("Add Shelf", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .contentShape(Rectangle())
        }
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .confirmationDialog("Delete Cabinet?", isPresented: $showDeleteConfirmation) {
            Button("Delete Cabinet", role: .destructive) {
                cabinet.delete()
            }
        } message: {
            Text("Are you sure you want to delete this cabinet?\n\nThis will also delete all of its shelves, drinks, and associated log entries.\n\nThis action cannot be undone.")
        }
    }

    var infoButton: some View {
        Button {
            isCabinetModPresented = .edit(cabinet)
        } label: {
            Label("Info", systemImage: "info")
        }
    }

    var addShelfButton: some View {
        Button {
            isShelfModPresented = .add(cabinet)
        } label: {
            Label("Add Shelf", systemImage: "plus")
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
