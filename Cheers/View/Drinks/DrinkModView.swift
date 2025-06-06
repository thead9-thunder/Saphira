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
                BrandPickerButton(selectedBrand: $brand)
                ShelfPicker(selectedShelf: $shelf)
            }
        }
        .navigationTitle(title)
        .toolbar { toolbar }
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

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                commit()
            } label: {
                Text("Done")
            }
            .disabled(!isFormValid)
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
