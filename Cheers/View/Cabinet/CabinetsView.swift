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

    init(cabinets: FetchDescriptor<Cabinet> = Cabinet.alphabetical) {
        _cabinets = Query(cabinets)
    }

    var body: some View {
        ForEach(cabinets) { cabinet in
            Section {
                ShelvesView(shelves: Shelf.inCabinet(cabinet))
            } header: {
                CabinetHeaderView(cabinet: cabinet)
            }
        }
    }
}
