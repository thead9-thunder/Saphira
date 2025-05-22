//
//  BrandModView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI

struct BrandModView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var mode: Mode
    var onCommit: (Brand) -> Void

    @State var name: String

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(mode: Mode, onCommit: @escaping (Brand) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add:
            _name = State(initialValue: "")
        case .edit(let brand):
            _name = State(initialValue: brand.name)
        }
    }

    var body: some View {
        Form {
            TextField("Name", text: $name, prompt: Text("Name"))
        }
        .navigationTitle(title)
        .toolbar { toolbar }
    }

    var title: String {
        switch mode {
        case .add:
            "Add Brand"
        case .edit:
            "Edit Brand"
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
        var committedBrand: Brand

        switch mode {
        case .add:
            committedBrand = Brand.create(named: name, for: modelContext)
        case .edit(let brand):
            brand.name = name
            committedBrand = brand
        }

        dismiss()
        onCommit(committedBrand)
    }
}

extension BrandModView {
    enum Mode: Identifiable {
        case add
        case edit(Brand)

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
