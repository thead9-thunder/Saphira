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
    @State private var showingDeleteConfirmation = false

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
        .alert("Delete Cabinet", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if case .edit(let cabinet) = mode {
                    cabinet.delete()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this cabinet? This will delete all shelves and drinks in this cabinet. This action cannot be undone.")
        }
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
        modSheet(activeSheet: activeSheet, detents: [.medium]) { mode in
            CabinetModView(mode: mode, onCommit: onCommit)
        }
    }
}
