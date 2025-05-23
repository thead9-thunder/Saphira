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

    var mode: Mode
    var onCommit: (Shelf) -> Void

    @State var name: String
    @State var cabinet: Cabinet?
    @State private var showingDeleteConfirmation = false

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
            
            Section {
                HStack {
                    Spacer()
                    Button(action: commit) {
                        Label {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                        } icon: {
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
                        .shadow(radius: 4)
                    }
                    .disabled(!isFormValid)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(title)
        .toolbar { toolbar }
        .alert("Delete Shelf", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if case .edit(let shelf) = mode {
                    shelf.delete()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this shelf? This action cannot be undone.")
        }
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
                Text("Cancel")
            }
        }

        if case .edit = mode {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
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
