//
//  TastingModView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI

struct TastingModView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var mode: Mode
    var onCommit: (Tasting) -> Void

    @State var notes: String
    @State var date: Date
    @State private var showingDeleteConfirmation = false

    var isFormValid: Bool { true }

    init(mode: Mode, onCommit: @escaping (Tasting) -> Void = { _ in }) {
        self.mode = mode
        self.onCommit = onCommit

        switch mode {
        case .add:
            _notes = State(initialValue: "")
            _date = State(initialValue: .now)
        case .edit(let tasting):
            _notes = State(initialValue: tasting.notes ?? "")
            _date = State(initialValue: tasting.date)
        }
    }

    var body: some View {
        Form {
            Section {
                DatePicker("Date", selection: $date)
            }

            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
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
        .alert("Delete Tasting", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if case .edit(let tasting) = mode {
                    tasting.delete()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this tasting? This action cannot be undone.")
        }
    }

    var title: String {
        switch mode {
        case .add:
            "Add Tasting"
        case .edit:
            "Edit Tasting"
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
        withAnimation {
            var committedTasting: Tasting

            switch mode {
            case .add(let drink):
                    committedTasting = Tasting.create(for: drink, at: date)
                    committedTasting.notes = notes
            case .edit(let tasting):
                tasting.date = date
                tasting.notes = notes
                committedTasting = tasting
            }

            dismiss()
            onCommit(committedTasting)
        }
    }
}

// MARK: - Mode
extension TastingModView {
    enum Mode: Identifiable {
        case add(Drink)
        case edit(Tasting)

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
    func tastingModSheet(
        activeSheet: Binding<TastingModView.Mode?>,
        onCommit: @escaping (Tasting) -> Void = { _ in }
    ) -> some View {
        modSheet(activeSheet: activeSheet, detents: [.medium]) { mode in
            TastingModView(mode: mode, onCommit: onCommit)
        }
    }
}
