//
//  DrinkView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI

struct DrinkView: View {
    let drink: Drink
    
    var body: some View {
        VStack {
            Text("Brand: \(drink.brand?.name ?? "No Brand")")
            TastingsView(tastings: Tasting.forDrink(drink))
        }
        .navigationTitle(drink.name)
        .floatingButton(label: "Add to Logbook", systemImage: "book.pages", position: .bottomCenter) {
            Tasting.create(for: drink)
        }
    }
}
