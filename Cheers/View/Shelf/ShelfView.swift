//
//  ShelfView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/20/25.
//

import Foundation
import SwiftUI

struct ShelfView: View {
    @Environment(\.navigationState) private var navigationState
    private var selectedDrinkBinding: Binding<Drink?> {
        Binding<Drink?>(
            get: { navigationState.selectedDrink },
            set: { navigationState.selectedDrink = $0 }
        )
    }

    let shelf: Shelf

    @State private var isDrinkModPresented: DrinkModView.Mode?

    var body: some View {
        VStack {
            List(selection: selectedDrinkBinding) {
                DrinksView(drinks: Drink.on(shelf: shelf))
            }
        }
        .navigationTitle(shelf.name)
        .floatingButton(systemImageName: "plus", position: .bottomCenter) {
            isDrinkModPresented = .add(DrinkModView.Config(shelf: shelf))
        }
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }
}
