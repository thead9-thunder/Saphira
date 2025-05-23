//
//  TastingCell.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI

struct TastingCell: View {
    let tasting: Tasting

    @State private var activeSheet: TastingModView.Mode?

    var body: some View {
        Button {
            activeSheet = .edit(tasting)
        } label: {
            VStack(alignment: .leading) {
                Label {
                    Text(tasting.date.formatted(date: .abbreviated, time: .shortened))
                } icon: {
                    Image(systemName: "calendar")
                }
                .foregroundStyle(.secondary)
                .font(.caption)

                if let notes = tasting.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tastingModSheet(activeSheet: $activeSheet)
    }
}
