//
//  CheersView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct CheersView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationTitle("Cheers")
        } content: {
//            if let shelf = navigationState.selectedShelf {
//                ShelfView(shelf: shelf)
//            } else {
//                ContentUnavailableView(
//                    "No Shelf Selected",
//                    systemImage: "square.stack.3d.up",
//                    description: Text("Please select a shelf from the sidebar")
//                )
//            }
        } detail: {
//            if let drink = navigationState.selectedDrink {
//                DrinkView(drink: drink)
//            } else {
//                ContentUnavailableView(
//                    "No Drink Selected",
//                    systemImage: "wineglass",
//                    description: Text("Please select a drink")
//                )
//            }
        }
    }
}

#Preview {
    CheersView()
}
