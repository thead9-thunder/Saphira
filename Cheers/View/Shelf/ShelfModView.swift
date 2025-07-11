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
    @State var icon: Icon

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(mode: Mode, onCommit: @escaping (Shelf) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add(let config):
            _name = State(initialValue: config.name ?? "")
            _cabinet = State(initialValue: config.cabinet)
            _icon = State(initialValue: config.cabinet?.icon ?? .sfSymbol("cup.and.saucer"))
        case .edit(let shelf):
            _name = State(initialValue: shelf.name)
            _cabinet = State(initialValue: shelf.cabinet)
            _icon = State(initialValue: shelf.icon)
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name, prompt: Text("Name"))
                NavigationLink(destination: IconPicker(icon: $icon)) {
                    IconLabel("Icon", icon: icon)
                }
            }

            Section {
                CabinetPicker(selectedCabinet: $cabinet)
            } header: {
                Text("Shelf Location")
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
            .tint(.accentColor)
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
            committedShelf.icon = icon
            navigationState.navigate(to: .shelf(committedShelf))
        case .edit(let shelf):
            shelf.name = name
            shelf.cabinet = cabinet
            shelf.icon = icon
            committedShelf = shelf
        }

        dismiss()
        onCommit(committedShelf)
    }
}

// MARK: - Mode
extension ShelfModView {
    enum Mode: Identifiable {
        case add(Config)
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
    
    struct Config {
        var name: String?
        var cabinet: Cabinet?
    }
}

// MARK: - View Extensions
extension View {
    func shelfModSheet(
        activeSheet: Binding<ShelfModView.Mode?>,
        onCommit: @escaping (Shelf) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.large]) { mode in
            ShelfModView(mode: mode, onCommit: onCommit)
        }
    }
}
