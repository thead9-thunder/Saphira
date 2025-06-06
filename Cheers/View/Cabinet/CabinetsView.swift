//
//  CabinetsView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData

struct CabinetsView: View {
    @Query var cabinets: [Cabinet]

    @State private var isShelfModPresented: ShelfModView.Mode?

    init(cabinets: FetchDescriptor<Cabinet> = Cabinet.alphabetical) {
        _cabinets = Query(cabinets)
    }

    var body: some View {
        ForEach(cabinets) { cabinet in
            Section {
                if cabinet.shelves?.count ?? 0 == 0 {
                    Button {
                        isShelfModPresented = .add(cabinet)
                    } label: {
                        Label("Add Shelf", systemImage: "plus")
                    }
                    .shelfModSheet(activeSheet: $isShelfModPresented)
                } else {
                    ShelvesView(shelves: Shelf.inCabinet(cabinet))
                }
            } header: {
                CabinetHeaderView(cabinet: cabinet)
            }
        }
    }
}
