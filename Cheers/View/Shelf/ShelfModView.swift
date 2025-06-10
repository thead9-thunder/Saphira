//
//  ShelfModView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI

struct ShelfModView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigationState) private var navigationState

    var mode: Mode
    var onCommit: (Shelf) -> Void

    @State var name: String
    @State var cabinet: Cabinet?

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(mode: Mode, onCommit: @escaping (Shelf) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add(let cabinet):
            _name = State(initialValue: "")
            _cabinet = State(initialValue: cabinet)
        case .edit(let shelf):
            _name = State(initialValue: shelf.name)
            _cabinet = State(initialValue: shelf.cabinet)
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name, prompt: Text("Name"))
            }

            Section {
                CabinetPicker(selectedCabinet: $cabinet)
            }
        }
        .navigationTitle(title)
        .toolbar { toolbar }
    }

    var title: String {
        switch mode {
        case .add:
            "Add Shelf"
        case .edit:
            "Edit Shelf"
        }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Label("Cancel", systemImage: "xmark")
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                commit()
            } label: {
                Label("Done", systemImage: "checkmark")
            }
            .disabled(!isFormValid)
        }
    }

    func commit() {
        var committedShelf: Shelf

        switch mode {
        case .add:
            if let cabinet {
                committedShelf = Shelf.create(named: name, in: cabinet)
            } else {
                committedShelf = Shelf.create(named: name, for: modelContext)
            }
            navigationState.navigate(to: .shelf(committedShelf))
        case .edit(let shelf):
            shelf.name = name
            shelf.cabinet = cabinet
            committedShelf = shelf
        }

        dismiss()
        onCommit(committedShelf)
    }
}

// MARK: - Mode
extension ShelfModView {
    enum Mode: Identifiable {
        case add(Cabinet? = nil)
        case edit(Shelf)

        var id: String {
            switch self {
            case .add:
                "add"
            case .edit:
                "edit"
            }
        }
    }
}

// MARK: - View Extensions
extension View {
    func shelfModSheet(
        activeSheet: Binding<ShelfModView.Mode?>,
        onCommit: @escaping (Shelf) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.medium]) { mode in
            ShelfModView(mode: mode, onCommit: onCommit)
        }
    }
}
