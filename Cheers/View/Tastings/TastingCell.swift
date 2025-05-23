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
            Label {
                VStack(alignment: .leading) {
                    Text(tasting.date.formatted(date: .abbreviated, time: .shortened))

                    if let notes = tasting.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.body)
                    }
                }
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tastingModSheet(activeSheet: $activeSheet)
    }
}
