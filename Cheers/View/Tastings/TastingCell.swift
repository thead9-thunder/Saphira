//
//  TastingCell.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI

struct TastingCell: View {
    let tasting: Tasting

    @State private var isTastingModPresented: TastingModView.Mode?
    @State private var showDeleteConfirmation = false

    var body: some View {
        Button {
            isTastingModPresented = .edit(tasting)
        } label: {
            Label {
                VStack(alignment: .leading) {
                    Text(tasting.date.formatted(date: .abbreviated, time: .shortened))

                    if let notes = tasting.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.body)
                    }
                }
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu { contextMenu }
        .swipeActions(edge: .trailing) {
            infoButton
            deleteButton
        }
        .tastingModSheet(activeSheet: $isTastingModPresented)
        .confirmationDialog("Delete Tasting?", isPresented: $showDeleteConfirmation) {
            Button("Delete Tasting", role: .destructive) {
                tasting.delete()
            }
        } message: {
            Text("Are you sure you want to delete this tasting?\n\nThis action cannot be undone.")
        }
    }

    @ViewBuilder
    var contextMenu: some View {
        infoButton

        Divider()

        deleteButton
    }

    var infoButton: some View {
        Button {
            isTastingModPresented = .edit(tasting)
        } label: {
            Label("Info", systemImage: "info")
        }
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
