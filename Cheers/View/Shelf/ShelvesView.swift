//
//  ShelvesView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShelvesView: View {
    @Query var shelves: [Shelf]

    init(shelves: FetchDescriptor<Shelf> = Shelf.alphabetical) {
        _shelves = Query(shelves)
    }

    init(shelves: Query<Shelf, Array<Shelf>>) {
        _shelves = shelves
    }

    var body: some View {
        ForEach(shelves) { shelf in
            NavigationLink(value: NavigationDestination.shelf(shelf)) {
                ShelfCellView(shelf: shelf)
            }
        }
    }
}
