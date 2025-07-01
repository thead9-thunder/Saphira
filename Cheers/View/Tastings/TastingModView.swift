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
        }
        .navigationTitle(title)
        .toolbar { toolbar }
    }

    var title: String {
        switch mode {
        case .add:
            "Add to Logbook"
        case .edit:
            "Edit Log Entry"
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
        withAnimation {
            var committedTasting: Tasting

            switch mode {
            case .add(let drink):
                    committedTasting = Tasting.create(for: drink, at: date)
                    committedTasting.notes = notes
                    
                    // Show toast notification for new log entry
                    ToastManager.shared.showDrinkLoggedToast(for: drink)
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
