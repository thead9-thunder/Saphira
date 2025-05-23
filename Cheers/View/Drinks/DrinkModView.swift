//
//  DrinkModView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI

struct DrinkModView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var mode: Mode
    var onCommit: (Drink) -> Void
    @State var name: String
    @State var brand: Brand?
    @State var shelf: Shelf?
    @State private var showingDeleteConfirmation = false

    var isFormValid: Bool { isNameValid && isShelfValid }
    var isNameValid: Bool { !name.isEmpty }
    var isShelfValid: Bool { shelf != nil }

    init(mode: Mode, onCommit: @escaping (Drink) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add(let config):
            _name = State(initialValue: "")
            _brand = State(initialValue: config.brand)
            _shelf = State(initialValue: config.shelf)
        case .edit(let drink):
            _name = State(initialValue: drink.name)
            _brand = State(initialValue: drink.brand)
            _shelf = State(initialValue: drink.shelf)
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name, prompt: Text("Name"))
            }

            Section {
                BrandPicker(selectedBrand: $brand)
                ShelfPicker(selectedShelf: $shelf)
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
        .alert("Delete Drink", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if case .edit(let drink) = mode {
                    drink.delete()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this drink? This action cannot be undone.")
        }
    }

    var title: String {
        switch mode {
        case .add:
            "Add Drink"
        case .edit:
            "Edit Drink"
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
        var committedDrink: Drink

        switch mode {
        case .add:
            committedDrink = Drink.create(named: name, for: modelContext)
            committedDrink.brand = brand
            committedDrink.shelf = shelf
        case .edit(let drink):
            drink.name = name
            drink.brand = brand
            drink.shelf = shelf
            committedDrink = drink
        }

        dismiss()
        onCommit(committedDrink)
    }
}

// MARK: - Mode
extension DrinkModView {
    enum Mode: Identifiable {
        case add(Config)
        case edit(Drink)

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
        var brand: Brand? = nil
        var shelf: Shelf? = nil
    }
}

// MARK: - View Extensions
extension View {
    func drinkModSheet(
        activeSheet: Binding<DrinkModView.Mode?>,
        onCommit: @escaping (Drink) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.medium]) { mode in
            DrinkModView(mode: mode, onCommit: onCommit)
        }
    }
}

// MARK: - Previews
#Preview {
    NavigationStack {
        DrinkModView(mode: .add(DrinkModView.Config()))
    }
}
