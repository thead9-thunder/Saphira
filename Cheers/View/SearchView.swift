//
//  SearchView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/16/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchView: View {
    @Query private var shelves: [Shelf]
    @Query private var drinks: [Drink]

    @State private var isShelvesExpanded = true
    @State private var isDrinksExpanded = true

    init(searchText: String) {
        
    }

    var body: some View {
        List {
            DisclosureGroup("Shelves", isExpanded: $isShelvesExpanded) {
                ForEach(shelves) { shelf in
                    Text(shelf.name)
                }
            }

            DisclosureGroup("Drink", isExpanded: $isDrinksExpanded) {
                ForEach(drinks) { drink in
                    Text(drink.name)
                }
            }
        }
    }
}
