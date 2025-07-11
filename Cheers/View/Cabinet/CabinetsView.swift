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

    @Binding private var isShelfModPresented: ShelfModView.Mode?

    init(
        cabinets: FetchDescriptor<Cabinet> = Cabinet.alphabetical,
        isShelfModPresented: Binding<ShelfModView.Mode?>
    ) {
        _cabinets = Query(cabinets)
        _isShelfModPresented = isShelfModPresented
    }

    var body: some View {
        ForEach(cabinets) { cabinet in
            Section {
                if cabinet.shelves?.count ?? 0 == 0 {
                    Button {
                        isShelfModPresented = .add(.init(cabinet: cabinet))
                    } label: {
                        Label("Add Shelf", systemImage: "plus")
                    }
                } else {
                    ShelvesView(shelves: Shelf.inCabinet(cabinet))
                }
            } header: {
                CabinetHeaderView(cabinet: cabinet)
            }
        }
    }
}
