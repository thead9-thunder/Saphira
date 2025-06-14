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
    @Environment(\.navigationState) private var navigationState

    var mode: Mode
    var onCommit: (Brand) -> Void

    @State var name: String

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(
        mode: Mode,
        navigateOnNew: Bool = true,
        onCommit: @escaping (Brand) -> Void = { _ in }
    ) {
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
            Section {
                TextField("Name", text: $name, prompt: Text("Name"))
            }
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
        var committedBrand: Brand

        switch mode {
        case .add:
            committedBrand = Brand.create(named: name, for: modelContext)
            navigationState.navigate(to: .brand(committedBrand))
        case .edit(let brand):
            brand.name = name
            committedBrand = brand
        }

        dismiss()
        onCommit(committedBrand)
    }
}

// MARK: - Mode
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

// MARK: - View Extensions
extension View {
    func brandModSheet(
        activeSheet: Binding<BrandModView.Mode?>,
        onCommit: @escaping (Brand) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.medium]) { mode in
            BrandModView(mode: mode, onCommit: onCommit)
        }
    }
}
