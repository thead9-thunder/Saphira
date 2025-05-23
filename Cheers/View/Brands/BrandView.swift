//
//  BrandView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI
import SwiftData

struct BrandView: View {
    var brand: Brand

    var body: some View {
        DrinksView(config: drinksViewConfig)
            .navigationTitle(brand.name)
    }
}

extension BrandView {
    var drinksViewConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.by(brand: brand)),
            latestTastings: Query(Tasting.forBrand(brand, limit: 10))
        )
    }
}
