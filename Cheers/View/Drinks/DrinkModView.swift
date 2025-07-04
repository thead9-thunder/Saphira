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
    @Environment(\.navigationState) private var navigationState

    var mode: Mode
    var onCommit: (Drink) -> Void
    @State var name: String
    @State var brand: Brand?
    @State var shelf: Shelf?
    @State var icon: Icon

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
            _icon = State(initialValue: config.shelf?.icon ?? .sfSymbol("cup.and.saucer"))
        case .edit(let drink):
            _name = State(initialValue: drink.name)
            _brand = State(initialValue: drink.brand)
            _shelf = State(initialValue: drink.shelf)
            _icon = State(initialValue: drink.icon)
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
        var committedDrink: Drink

        switch mode {
        case .add:
            committedDrink = Drink.create(named: name, for: modelContext)
            committedDrink.brand = brand
            committedDrink.shelf = shelf
            committedDrink.icon = icon
            navigationState.navigate(to: .drink(committedDrink))
            
            // Show toast notification for new drink
            ToastManager.shared.showDrinkCreatedToast(for: committedDrink)
        case .edit(let drink):
            drink.name = name
            drink.brand = brand
            drink.shelf = shelf
            drink.icon = icon
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
        modSheet(activeSheet: activeSheet, detents: [.large]) { mode in
            DrinkModView(mode: mode, onCommit: onCommit)
        }
    }
}
