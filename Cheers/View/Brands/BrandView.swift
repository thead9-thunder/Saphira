//
//  BrandView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI

struct BrandView: View {
    var brand: Brand

    var body: some View {
        VStack {
            List {
                DrinksView(drinks: Drink.by(brand: brand))
            }
        }
        .navigationTitle(brand.name)
    }
}
