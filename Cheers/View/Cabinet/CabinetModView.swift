//
//  CabinetModView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI

struct CabinetModView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var mode: Mode
    var onCommit: (Cabinet) -> Void

    @State var name: String

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(mode: Mode, onCommit: @escaping (Cabinet) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add:
            _name = State(initialValue: "")
        case .edit(let cabinet):
            _name = State(initialValue: cabinet.name)
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
            "Add Cabinet"
        case .edit:
            "Edit Cabinet"
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
        var committedCabinet: Cabinet

        switch mode {
        case .add:
            committedCabinet = Cabinet.create(named: name, for: modelContext)
        case .edit(let cabinet):
            cabinet.name = name
            committedCabinet = cabinet
        }

        dismiss()
        onCommit(committedCabinet)
    }
}

extension CabinetModView {
    enum Mode: Identifiable {
        case add
        case edit(Cabinet)

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
