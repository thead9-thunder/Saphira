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
    @State var icon: Icon

    var isFormValid: Bool { isNameValid }
    var isNameValid: Bool { !name.isEmpty }

    init(mode: Mode, onCommit: @escaping (Cabinet) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add:
            _name = State(initialValue: "")
            _icon = State(initialValue: .sfSymbol("cabinet"))
        case .edit(let cabinet):
            _name = State(initialValue: cabinet.name)
            _icon = State(initialValue: cabinet.icon)
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
        var committedCabinet: Cabinet

        switch mode {
        case .add:
            committedCabinet = Cabinet.create(named: name, for: modelContext)
            committedCabinet.icon = icon
        case .edit(let cabinet):
            cabinet.name = name
            cabinet.icon = icon
            committedCabinet = cabinet
        }

        dismiss()
        onCommit(committedCabinet)
    }
}

// MARK: - Mode
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

// MARK: - View Extensions
extension View {
    func cabinetModSheet(
        activeSheet: Binding<CabinetModView.Mode?>,
        onCommit: @escaping (Cabinet) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.large]) { mode in
            CabinetModView(mode: mode, onCommit: onCommit)
        }
    }
}
