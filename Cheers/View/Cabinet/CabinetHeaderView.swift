//
//  CabinetHeaderView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI

struct CabinetHeaderView: View {
    let cabinet: Cabinet

    @State private var isCabinetModPresented: CabinetModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?

    var body: some View {
        HStack {
            Label(cabinet.name, systemImage: "cabinet")
                .font(.title2)
                .foregroundStyle(Color(.label))

            Spacer()

            Menu {
                Button {
                    isShelfModPresented = .add(cabinet)
                } label: {
                    Label("Add Shelf", systemImage: "plus")
                }

                Button {
                    isCabinetModPresented = .edit(cabinet)
                } label: {
                    Label("Edit Cabinet", systemImage: "pencil")
                }
            } label: {
                Label("Add Shelf", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
            }
        }
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .textCase(nil)
    }
}
