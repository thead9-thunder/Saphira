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
    @State var name: String
    @State var brand: Brand?
    @State var shelf: Shelf?

    var isFormValid: Bool { isNameValid && isShelfValid }
    var isNameValid: Bool { !name.isEmpty }
    var isShelfValid: Bool { shelf != nil }

    init(mode: Mode) {
        self.mode = mode

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
            TextField("Name", text: $name, prompt: Text("Name"))
            BrandPicker(selectedBrand: $brand)
            ShelfPicker(selectedShelf: $shelf)
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
                Text("Save")
            }
            .disabled(!isFormValid)
        }
    }

    func commit() {
        switch mode {
        case .add:
            let createdDrink = Drink.create(named: name, for: modelContext)
            createdDrink.brand = brand
            createdDrink.shelf = shelf
        case .edit(let drink):
            drink.name = name
            drink.brand = brand
            drink.shelf = shelf
        }

        dismiss()
    }
}

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

#Preview {
    NavigationStack {
        DrinkModView(mode: .add(DrinkModView.Config()))
    }
}
