//
//  DrinksView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct DrinksView: View {
    @Query var drinks: [Drink]

    init(drinks: FetchDescriptor<Drink> = Drink.alphabetical) {
        _drinks = Query(drinks)
    }

    var body: some View {
        ForEach(drinks) { drink in
            NavigationLink(value: drink) {
                DrinkCellView(drink: drink)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DrinksView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
